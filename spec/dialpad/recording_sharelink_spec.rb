require 'spec_helper'

RSpec.describe Dialpad::RecordingSharelink do
  let(:base_url) { 'https://api.dialpad.com' }
  let(:token) { 'test_token' }
  let(:client) { Dialpad::Client.new(base_url: base_url, token: token) }

  before do
    allow(Dialpad).to receive(:client).and_return(client)
  end

  describe 'class methods' do
    describe '.retrieve' do
      context 'with valid ID' do
        let(:recording_sharelink_data) do
          {
            'access_link' => 'https://dialpad.com/recording/admincallrecording/testLinkId123456789',
            'call_id' => '1234567890123456',
            'created_by_id' => '9876543210987654',
            'date_added' => '2026-02-03T10:44:38.988809',
            'id' => 'testLinkId123456789',
            'item_id' => '5555666677778888',
            'privacy' => 'company',
            'type' => 'admincallrecording'
          }
        end

        it 'retrieves a recording sharelink by ID' do
          stub_request(:get, "#{base_url}/recordingsharelink/test123")
            .with(headers: { 'Authorization' => "Bearer #{token}" })
            .to_return(status: 200, body: recording_sharelink_data.to_json, headers: { 'Content-Type' => 'application/json' })

          sharelink = described_class.retrieve('test123')

          expect(sharelink).to be_a(described_class)
          expect(sharelink.id).to eq('testLinkId123456789')
          expect(sharelink.access_link).to eq('https://dialpad.com/recording/admincallrecording/testLinkId123456789')
          expect(sharelink.call_id).to eq('1234567890123456')
          expect(sharelink.created_by_id).to eq('9876543210987654')
          expect(sharelink.date_added).to eq('2026-02-03T10:44:38.988809')
          expect(sharelink.item_id).to eq('5555666677778888')
          expect(sharelink.privacy).to eq('company')
          expect(sharelink.type).to eq('admincallrecording')
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.retrieve(nil) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.retrieve('') }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end
    end

    describe '.create' do
      context 'with valid attributes' do
        let(:create_attributes) do
          {
            recording_id: '1234567890123456',
            recording_type: 'admincallrecording'
          }
        end

        let(:created_sharelink_data) do
          {
            'access_link' => 'https://dialpad.com/recording/admincallrecording/newTestLinkId987654321',
            'call_id' => '1234567890123456',
            'created_by_id' => '9876543210987654',
            'date_added' => '2026-02-03T11:30:15.123456',
            'id' => 'newTestLinkId987654321',
            'item_id' => '1234567890123456',
            'privacy' => 'company',
            'type' => 'admincallrecording'
          }
        end

        it 'creates a new recording sharelink' do
          stub_request(:post, "#{base_url}/recordingsharelink")
            .with(
              headers: { 'Authorization' => "Bearer #{token}" },
              body: create_attributes.to_json
            )
            .to_return(status: 201, body: created_sharelink_data.to_json, headers: { 'Content-Type' => 'application/json' })

          sharelink = described_class.create(create_attributes)

          expect(sharelink).to be_a(described_class)
          expect(sharelink.id).to eq('newTestLinkId987654321')
          expect(sharelink.access_link).to eq('https://dialpad.com/recording/admincallrecording/newTestLinkId987654321')
          expect(sharelink.call_id).to eq('1234567890123456')
          expect(sharelink.created_by_id).to eq('9876543210987654')
          expect(sharelink.item_id).to eq('1234567890123456')
          expect(sharelink.privacy).to eq('company')
          expect(sharelink.type).to eq('admincallrecording')
        end
      end

      context 'with missing required attributes' do
        it 'raises RequiredAttributeError when recording_id is missing' do
          expect { described_class.create({ recording_type: 'admincallrecording' }) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attributes: recording_id'
          )
        end

        it 'raises RequiredAttributeError when recording_type is missing' do
          expect { described_class.create({ recording_id: '123' }) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attributes: recording_type'
          )
        end

        it 'raises RequiredAttributeError when both required attributes are missing' do
          expect { described_class.create({}) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attributes: recording_id, recording_type'
          )
        end
      end
    end

    describe '.update' do
      context 'with valid ID and attributes' do
        let(:update_attributes) do
          {
            privacy: 'public'
          }
        end

        let(:updated_sharelink_data) do
          {
            'access_link' => 'https://dialpad.com/recording/admincallrecording/testLinkId123456789',
            'call_id' => '1234567890123456',
            'created_by_id' => '9876543210987654',
            'date_added' => '2026-02-03T10:44:38.988809',
            'id' => 'testLinkId123456789',
            'item_id' => '5555666677778888',
            'privacy' => 'public',
            'type' => 'admincallrecording'
          }
        end

        it 'updates a recording sharelink' do
          stub_request(:put, "#{base_url}/recordingsharelink/test123")
            .with(
              headers: { 'Authorization' => "Bearer #{token}" },
              body: update_attributes.to_json
            )
            .to_return(status: 200, body: updated_sharelink_data.to_json, headers: { 'Content-Type' => 'application/json' })

          sharelink = described_class.update('test123', update_attributes)

          expect(sharelink).to be_a(described_class)
          expect(sharelink.id).to eq('testLinkId123456789')
          expect(sharelink.privacy).to eq('public')
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.update(nil, {}) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.update('', {}) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end

      context 'with missing required attributes' do
        it 'raises RequiredAttributeError when privacy is missing' do
          expect { described_class.update('test123', {}) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attributes: privacy'
          )
        end
      end
    end

    describe '.destroy' do
      context 'with valid ID' do
        let(:destroyed_sharelink_data) do
          {
            'access_link' => 'https://dialpad.com/recording/admincallrecording/testLinkId123456789',
            'call_id' => '1234567890123456',
            'created_by_id' => '9876543210987654',
            'date_added' => '2026-02-03T10:44:38.988809',
            'id' => 'testLinkId123456789',
            'item_id' => '5555666677778888',
            'privacy' => 'company',
            'type' => 'admincallrecording'
          }
        end

        it 'destroys a recording sharelink' do
          stub_request(:delete, "#{base_url}/recordingsharelink/test123")
            .with(headers: { 'Authorization' => "Bearer #{token}" })
            .to_return(status: 200, body: destroyed_sharelink_data.to_json, headers: { 'Content-Type' => 'application/json' })

          sharelink = described_class.destroy('test123')

          expect(sharelink).to be_a(described_class)
          expect(sharelink.id).to eq('testLinkId123456789')
          expect(sharelink.access_link).to eq('https://dialpad.com/recording/admincallrecording/testLinkId123456789')
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.destroy(nil) }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.destroy('') }.to raise_error(
            Dialpad::RecordingSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end
    end
  end

  describe 'instance methods' do
    let(:sharelink_attributes) do
      {
        access_link: 'https://dialpad.com/recording/admincallrecording/testLinkId123456789',
        call_id: '1234567890123456',
        created_by_id: '9876543210987654',
        date_added: '2026-02-03T10:44:38.988809',
        id: 'testLinkId123456789',
        item_id: '5555666677778888',
        privacy: 'company',
        type: 'admincallrecording'
      }
    end

    let(:sharelink) { described_class.new(sharelink_attributes) }

    describe '#initialize' do
      it 'sets attributes from hash' do
        expect(sharelink.id).to eq('testLinkId123456789')
        expect(sharelink.access_link).to eq('https://dialpad.com/recording/admincallrecording/testLinkId123456789')
        expect(sharelink.call_id).to eq('1234567890123456')
        expect(sharelink.created_by_id).to eq('9876543210987654')
        expect(sharelink.date_added).to eq('2026-02-03T10:44:38.988809')
        expect(sharelink.item_id).to eq('5555666677778888')
        expect(sharelink.privacy).to eq('company')
        expect(sharelink.type).to eq('admincallrecording')
      end

      it 'converts string keys to symbols' do
        sharelink_with_string_keys = described_class.new(
          'id' => 'testLinkId123456789',
          'access_link' => 'https://dialpad.com/recording/test',
          'privacy' => 'public'
        )

        expect(sharelink_with_string_keys.id).to eq('testLinkId123456789')
        expect(sharelink_with_string_keys.access_link).to eq('https://dialpad.com/recording/test')
        expect(sharelink_with_string_keys.privacy).to eq('public')
      end

      it 'handles empty attributes' do
        empty_sharelink = described_class.new({})
        expect(empty_sharelink.attributes).to eq({})
      end
    end

    describe 'attribute access' do
      it 'allows access to all defined attributes' do
        expect(sharelink).to respond_to(:access_link)
        expect(sharelink).to respond_to(:call_id)
        expect(sharelink).to respond_to(:created_by_id)
        expect(sharelink).to respond_to(:date_added)
        expect(sharelink).to respond_to(:id)
        expect(sharelink).to respond_to(:item_id)
        expect(sharelink).to respond_to(:privacy)
        expect(sharelink).to respond_to(:type)
      end

      it 'raises NoMethodError for undefined attributes' do
        expect { sharelink.undefined_attribute }.to raise_error(NoMethodError)
      end
    end

    describe 'privacy values' do
      it 'handles admin privacy' do
        admin_sharelink = described_class.new(sharelink_attributes.merge(privacy: 'admin'))
        expect(admin_sharelink.privacy).to eq('admin')
      end

      it 'handles company privacy' do
        expect(sharelink.privacy).to eq('company')
      end

      it 'handles owner privacy' do
        owner_sharelink = described_class.new(sharelink_attributes.merge(privacy: 'owner'))
        expect(owner_sharelink.privacy).to eq('owner')
      end

      it 'handles public privacy' do
        public_sharelink = described_class.new(sharelink_attributes.merge(privacy: 'public'))
        expect(public_sharelink.privacy).to eq('public')
      end
    end

    describe 'type values' do
      it 'handles admincallrecording type' do
        expect(sharelink.type).to eq('admincallrecording')
      end

      it 'handles callrecording type' do
        callrecording_sharelink = described_class.new(sharelink_attributes.merge(type: 'callrecording'))
        expect(callrecording_sharelink.type).to eq('callrecording')
      end

      it 'handles voicemail type' do
        voicemail_sharelink = described_class.new(sharelink_attributes.merge(type: 'voicemail'))
        expect(voicemail_sharelink.type).to eq('voicemail')
      end
    end
  end

  describe 'error handling' do
    it 'defines RequiredAttributeError' do
      expect(Dialpad::RecordingSharelink::RequiredAttributeError).to be < Dialpad::DialpadObject::RequiredAttributeError
    end
  end

  describe 'API integration' do
    context 'when API returns error' do
      it 'handles 404 errors gracefully' do
        stub_request(:get, "#{base_url}/recordingsharelink/nonexistent")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 404, body: 'Not Found')

        expect { described_class.retrieve('nonexistent') }.to raise_error(Dialpad::APIError, /404 - Not Found/)
      end

      it 'handles 401 errors gracefully' do
        stub_request(:get, "#{base_url}/recordingsharelink/test123")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 401, body: 'Unauthorized')

        expect { described_class.retrieve('test123') }.to raise_error(Dialpad::APIError, /401 - Unauthorized/)
      end

      it 'handles 422 errors for create with invalid data' do
        stub_request(:post, "#{base_url}/recordingsharelink")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 422, body: 'Unprocessable Entity')

        expect { described_class.create({ recording_id: 'test', recording_type: 'admincallrecording' }) }.to raise_error(Dialpad::APIError, /422 - Unprocessable Entity/)
      end

      it 'handles 422 errors for update with invalid data' do
        stub_request(:put, "#{base_url}/recordingsharelink/test123")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 422, body: 'Unprocessable Entity')

        expect { described_class.update('test123', { privacy: 'invalid' }) }.to raise_error(Dialpad::APIError, /422 - Unprocessable Entity/)
      end
    end
  end
end
