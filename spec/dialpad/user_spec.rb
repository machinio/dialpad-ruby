require 'spec_helper'

RSpec.describe Dialpad::User do
  let(:base_url) { 'https://api.dialpad.com' }
  let(:token) { 'test_token' }
  let(:client) { Dialpad::Client.new(base_url: base_url, token: token) }

  before do
    allow(Dialpad).to receive(:client).and_return(client)
  end

  describe 'class methods' do
    describe '.retrieve' do
      context 'with valid ID' do
        let(:user_data) do
          {
            'admin_office_ids' => ['1234567890123456'],
            'company_id' => '9876543210987654',
            'country' => 'us',
            'date_active' => '2024-01-15T10:30:00.000000',
            'date_added' => '2024-01-10T09:00:00.000000',
            'date_first_login' => '2024-01-15T11:45:00.000000',
            'display_name' => 'John Doe',
            'do_not_disturb' => false,
            'emails' => ['john.doe@example.com'],
            'first_name' => 'John',
            'id' => '1111222233334444',
            'image_url' => 'https://example.com/avatar/user/test-avatar.png?version=abc123',
            'international_dialing_enabled' => false,
            'is_admin' => true,
            'is_available' => true,
            'is_on_duty' => false,
            'is_online' => true,
            'is_super_admin' => true,
            'language' => 'en',
            'last_name' => 'Doe',
            'license' => 'agents',
            'muted' => false,
            'office_id' => '1234567890123456',
            'onboarding_completed' => true,
            'phone_numbers' => ['+15551234567'],
            'state' => 'active',
            'timezone' => 'US/Pacific',
            'voicemail' => {
              'is_default_voicemail' => true,
              'name' => 'default',
              'voicemail_notifications_enabled' => true
            }
          }
        end

        it 'retrieves a user by ID' do
          stub_request(:get, "#{base_url}/users/1111222233334444")
            .with(headers: { 'Authorization' => "Bearer #{token}" })
            .to_return(status: 200, body: user_data.to_json, headers: { 'Content-Type' => 'application/json' })

          user = described_class.retrieve('1111222233334444')

          expect(user).to be_a(described_class)
          expect(user.id).to eq('1111222233334444')
          expect(user.first_name).to eq('John')
          expect(user.last_name).to eq('Doe')
          expect(user.display_name).to eq('John Doe')
          expect(user.emails).to eq(['john.doe@example.com'])
          expect(user.is_admin).to be true
          expect(user.is_super_admin).to be true
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.retrieve(nil) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.retrieve('') }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end
    end

    describe '.list' do
      context 'with users' do
        let(:users_data) do
          {
            'items' => [
              {
                'id' => '1111222233334444',
                'first_name' => 'John',
                'last_name' => 'Doe',
                'display_name' => 'John Doe',
                'emails' => ['john.doe@example.com'],
                'is_admin' => true
              },
              {
                'id' => '5555666677778888',
                'first_name' => 'Jane',
                'last_name' => 'Smith',
                'display_name' => 'Jane Smith',
                'emails' => ['jane.smith@example.com'],
                'is_admin' => false
              }
            ]
          }
        end

        it 'returns an array of users' do
          stub_request(:get, "#{base_url}/users")
            .with(headers: { 'Authorization' => "Bearer #{token}" })
            .to_return(status: 200, body: users_data.to_json, headers: { 'Content-Type' => 'application/json' })

          users = described_class.list

          expect(users).to be_an(Array)
          expect(users.length).to eq(2)
          expect(users.first).to be_a(described_class)
          expect(users.first.id).to eq('1111222233334444')
          expect(users.first.first_name).to eq('John')
          expect(users.first.is_admin).to be true
        end
      end
    end

    describe '.create' do
      let(:user_attributes) do
        {
          email: 'test.user@example.com',
          office_id: '1234567890123456',
          first_name: 'Test',
          last_name: 'User'
        }
      end

      let(:created_user_data) do
        {
          'id' => '9999888877776666',
          'first_name' => 'Test',
          'last_name' => 'User',
          'display_name' => 'Test User',
          'emails' => ['test.user@example.com'],
          'office_id' => '1234567890123456',
          'state' => 'active'
        }
      end

      context 'with valid attributes' do
        it 'creates a new user' do
          stub_request(:post, "#{base_url}/users")
            .with(
              headers: { 'Authorization' => "Bearer #{token}" },
              body: user_attributes.to_json
            )
            .to_return(status: 201, body: created_user_data.to_json, headers: { 'Content-Type' => 'application/json' })

          user = described_class.create(user_attributes)

          expect(user).to be_a(described_class)
          expect(user.id).to eq('9999888877776666')
          expect(user.first_name).to eq('Test')
          expect(user.last_name).to eq('User')
          expect(user.display_name).to eq('Test User')
          expect(user.emails).to eq(['test.user@example.com'])
        end
      end

      context 'with missing required attributes' do
        it 'raises RequiredAttributeError when email is missing' do
          attributes = { office_id: '1234567890123456' }

          expect { described_class.create(attributes) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attributes: email'
          )
        end

        it 'raises RequiredAttributeError when office_id is missing' do
          attributes = { email: 'test.user@example.com' }

          expect { described_class.create(attributes) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attributes: office_id'
          )
        end

        it 'raises RequiredAttributeError when both email and office_id are missing' do
          attributes = { first_name: 'Test', last_name: 'User' }

          expect { described_class.create(attributes) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attributes: email, office_id'
          )
        end

        it 'raises RequiredAttributeError when email is empty' do
          attributes = { email: '', office_id: '1234567890123456' }

          expect { described_class.create(attributes) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attributes: email'
          )
        end

        it 'raises RequiredAttributeError when office_id is nil' do
          attributes = { email: 'test.user@example.com', office_id: nil }

          expect { described_class.create(attributes) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attributes: office_id'
          )
        end
      end
    end

    describe '.update' do
      let(:update_attributes) do
        {
          first_name: 'Updated',
          last_name: 'Name',
          do_not_disturb: true
        }
      end

      let(:updated_user_data) do
        {
          'id' => '1111222233334444',
          'first_name' => 'Updated',
          'last_name' => 'Name',
          'display_name' => 'Updated Name',
          'emails' => ['john.doe@example.com'],
          'do_not_disturb' => true
        }
      end

      context 'with valid ID and attributes' do
        it 'updates a user' do
          stub_request(:patch, "#{base_url}/users/1111222233334444")
            .with(
              headers: { 'Authorization' => "Bearer #{token}" },
              body: update_attributes.to_json
            )
            .to_return(status: 200, body: updated_user_data.to_json, headers: { 'Content-Type' => 'application/json' })

          user = described_class.update('1111222233334444', update_attributes)

          expect(user).to be_a(described_class)
          expect(user.id).to eq('1111222233334444')
          expect(user.first_name).to eq('Updated')
          expect(user.last_name).to eq('Name')
          expect(user.do_not_disturb).to be true
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.update(nil, update_attributes) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.update('', update_attributes) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end
    end

    describe '.destroy' do
      let(:deleted_user_data) do
        {
          'id' => '1111222233334444',
          'first_name' => 'John',
          'last_name' => 'Doe',
          'state' => 'deleted'
        }
      end

      context 'with valid ID' do
        it 'deletes a user' do
          stub_request(:delete, "#{base_url}/users/1111222233334444")
            .with(headers: { 'Authorization' => "Bearer #{token}" })
            .to_return(status: 200, body: deleted_user_data.to_json, headers: { 'Content-Type' => 'application/json' })

          user = described_class.destroy('1111222233334444')

          expect(user).to be_a(described_class)
          expect(user.id).to eq('1111222233334444')
          expect(user.state).to eq('deleted')
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.destroy(nil) }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.destroy('') }.to raise_error(
            Dialpad::User::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end
    end
  end

  describe 'instance methods' do
    let(:user_attributes) do
      {
        id: '1111222233334444',
        admin_office_ids: ['1234567890123456'],
        company_id: '9876543210987654',
        country: 'us',
        date_active: '2024-01-15T10:30:00.000000',
        date_added: '2024-01-10T09:00:00.000000',
        date_first_login: '2024-01-15T11:45:00.000000',
        display_name: 'John Doe',
        do_not_disturb: false,
        emails: ['john.doe@example.com'],
        first_name: 'John',
        image_url: 'https://example.com/avatar/user/test-avatar.png?version=abc123',
        international_dialing_enabled: false,
        is_admin: true,
        is_available: true,
        is_on_duty: false,
        is_online: true,
        is_super_admin: true,
        language: 'en',
        last_name: 'Doe',
        license: 'agents',
        muted: false,
        office_id: '1234567890123456',
        onboarding_completed: true,
        phone_numbers: ['+15551234567'],
        state: 'active',
        timezone: 'US/Pacific',
        voicemail: {
          is_default_voicemail: true,
          name: 'default',
          voicemail_notifications_enabled: true
        }
      }
    end

    let(:user) { described_class.new(user_attributes) }

    describe '#initialize' do
      it 'sets attributes from hash' do
        expect(user.id).to eq('1111222233334444')
        expect(user.first_name).to eq('John')
        expect(user.last_name).to eq('Doe')
        expect(user.display_name).to eq('John Doe')
        expect(user.emails).to eq(['john.doe@example.com'])
        expect(user.phone_numbers).to eq(['+15551234567'])
        expect(user.company_id).to eq('9876543210987654')
        expect(user.office_id).to eq('1234567890123456')
        expect(user.is_admin).to be true
        expect(user.is_super_admin).to be true
        expect(user.is_online).to be true
        expect(user.is_available).to be true
        expect(user.state).to eq('active')
        expect(user.timezone).to eq('US/Pacific')
        expect(user.language).to eq('en')
        expect(user.license).to eq('agents')
        expect(user.country).to eq('us')
        expect(user.do_not_disturb).to be false
        expect(user.muted).to be false
        expect(user.onboarding_completed).to be true
        expect(user.international_dialing_enabled).to be false
      end

      it 'converts string keys to symbols' do
        user_with_string_keys = described_class.new(
          'id' => '1111222233334444',
          'first_name' => 'John',
          'is_admin' => true
        )

        expect(user_with_string_keys.id).to eq('1111222233334444')
        expect(user_with_string_keys.first_name).to eq('John')
        expect(user_with_string_keys.is_admin).to be true
      end

      it 'handles empty attributes' do
        empty_user = described_class.new({})
        expect(empty_user.attributes).to eq({})
      end

      it 'handles complex nested attributes like voicemail' do
        expect(user.voicemail).to eq({
                                       is_default_voicemail: true,
                                       name: 'default',
                                       voicemail_notifications_enabled: true
                                     })
      end

      it 'handles array attributes' do
        expect(user.admin_office_ids).to eq(['1234567890123456'])
        expect(user.emails).to eq(['john.doe@example.com'])
        expect(user.phone_numbers).to eq(['+15551234567'])
      end
    end

    describe 'attribute access' do
      it 'allows access to all defined attributes' do
        expect(user).to respond_to(:id)
        expect(user).to respond_to(:first_name)
        expect(user).to respond_to(:last_name)
        expect(user).to respond_to(:display_name)
        expect(user).to respond_to(:emails)
        expect(user).to respond_to(:phone_numbers)
        expect(user).to respond_to(:company_id)
        expect(user).to respond_to(:office_id)
        expect(user).to respond_to(:admin_office_ids)
        expect(user).to respond_to(:is_admin)
        expect(user).to respond_to(:is_super_admin)
        expect(user).to respond_to(:is_online)
        expect(user).to respond_to(:is_available)
        expect(user).to respond_to(:is_on_duty)
        expect(user).to respond_to(:state)
        expect(user).to respond_to(:timezone)
        expect(user).to respond_to(:language)
        expect(user).to respond_to(:license)
        expect(user).to respond_to(:country)
        expect(user).to respond_to(:do_not_disturb)
        expect(user).to respond_to(:muted)
        expect(user).to respond_to(:onboarding_completed)
        expect(user).to respond_to(:international_dialing_enabled)
        expect(user).to respond_to(:image_url)
        expect(user).to respond_to(:date_active)
        expect(user).to respond_to(:date_added)
        expect(user).to respond_to(:date_first_login)
        expect(user).to respond_to(:voicemail)
      end

      it 'raises NoMethodError for undefined attributes' do
        expect { user.undefined_attribute }.to raise_error(NoMethodError)
      end

      it 'responds to defined attributes' do
        expect(user.respond_to?(:first_name)).to be true
        expect(user.respond_to?(:last_name)).to be true
        expect(user.respond_to?(:id)).to be true
        expect(user.respond_to?(:is_admin)).to be true
        expect(user.respond_to?(:emails)).to be true
      end

      it 'does not respond to undefined attributes' do
        expect(user.respond_to?(:undefined_attribute)).to be false
      end
    end
  end

  describe 'constants' do
    it 'defines ATTRIBUTES constant' do
      expect(described_class::ATTRIBUTES).to be_an(Array)
      expect(described_class::ATTRIBUTES).to be_frozen
      expect(described_class::ATTRIBUTES).to include(
        :id,
        :first_name,
        :last_name,
        :emails,
        :phone_numbers,
        :company_id,
        :office_id,
        :is_admin,
        :is_super_admin,
        :display_name,
        :state,
        :timezone,
        :language
      )
    end

    it 'includes all expected attributes from the payload' do
      expected_attributes = %i(
        admin_office_ids
        company_id
        country
        date_active
        date_added
        date_first_login
        display_name
        do_not_disturb
        emails
        first_name
        id
        image_url
        international_dialing_enabled
        is_admin
        is_available
        is_on_duty
        is_online
        is_super_admin
        language
        last_name
        license
        muted
        office_id
        onboarding_completed
        phone_numbers
        state
        timezone
        voicemail
      )

      expected_attributes.each do |attr|
        expect(described_class::ATTRIBUTES).to include(attr)
      end
    end
  end

  describe 'error handling' do
    it 'defines RequiredAttributeError' do
      expect(Dialpad::User::RequiredAttributeError).to be < Dialpad::DialpadObject::RequiredAttributeError
    end
  end
end
