require 'spec_helper'

RSpec.describe Dialpad::CallReviewSharelink do
  let(:base_url) { 'https://api.dialpad.com' }
  let(:token) { 'test_token' }
  let(:client) { Dialpad::Client.new(base_url: base_url, token: token) }

  before do
    allow(Dialpad).to receive(:client).and_return(client)
  end

  describe 'class methods' do
    describe '.retrieve' do
      context 'with valid ID' do
        let(:call_review_sharelink_data) do
          {
            'access_link' => 'https://dialpad.com/callreview/testLinkId123456789',
            'call_id' => '1234567890123456',
            'id' => 'testLinkId123456789',
            'privacy' => 'company'
          }
        end

        it 'retrieves a call review sharelink by ID' do
          stub_request(:get, "#{base_url}/callreviewsharelink/test123")
            .with(headers: { 'Authorization' => "Bearer #{token}" })
            .to_return(status: 200, body: call_review_sharelink_data.to_json, headers: { 'Content-Type' => 'application/json' })

          sharelink = described_class.retrieve('test123')

          expect(sharelink).to be_a(described_class)
          expect(sharelink.id).to eq('testLinkId123456789')
          expect(sharelink.access_link).to eq('https://dialpad.com/callreview/testLinkId123456789')
          expect(sharelink.call_id).to eq('1234567890123456')
          expect(sharelink.privacy).to eq('company')
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.retrieve(nil) }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.retrieve('') }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end
    end

    describe '.create' do
      context 'with valid attributes' do
        let(:create_attributes) do
          {
            call_id: '1234567890123456',
            privacy: 'company'
          }
        end

        let(:created_sharelink_data) do
          {
            'access_link' => 'https://dialpad.com/callreview/newTestLinkId987654321',
            'call_id' => '1234567890123456',
            'id' => 'newTestLinkId987654321',
            'privacy' => 'company'
          }
        end

        it 'creates a new call review sharelink' do
          stub_request(:post, "#{base_url}/callreviewsharelink")
            .with(
              headers: { 'Authorization' => "Bearer #{token}" },
              body: create_attributes.to_json
            )
            .to_return(status: 201, body: created_sharelink_data.to_json, headers: { 'Content-Type' => 'application/json' })

          sharelink = described_class.create(create_attributes)

          expect(sharelink).to be_a(described_class)
          expect(sharelink.id).to eq('newTestLinkId987654321')
          expect(sharelink.access_link).to eq('https://dialpad.com/callreview/newTestLinkId987654321')
          expect(sharelink.call_id).to eq('1234567890123456')
          expect(sharelink.privacy).to eq('company')
        end
      end

      context 'with missing required attributes' do
        it 'raises RequiredAttributeError when call_id is missing' do
          expect { described_class.create({ privacy: 'company' }) }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attributes: call_id'
          )
        end

        it 'raises RequiredAttributeError when privacy is missing' do
          expect { described_class.create({ call_id: '123' }) }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attributes: privacy'
          )
        end

        it 'raises RequiredAttributeError when both required attributes are missing' do
          expect { described_class.create({}) }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attributes: call_id, privacy'
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
            'access_link' => 'https://dialpad.com/callreview/testLinkId123456789',
            'call_id' => '1234567890123456',
            'id' => 'testLinkId123456789',
            'privacy' => 'public'
          }
        end

        it 'updates a call review sharelink' do
          stub_request(:put, "#{base_url}/callreviewsharelink/test123")
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
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.update('', {}) }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end

      context 'with missing required attributes' do
        it 'raises RequiredAttributeError when privacy is missing' do
          expect { described_class.update('test123', {}) }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attributes: privacy'
          )
        end
      end
    end

    describe '.destroy' do
      context 'with valid ID' do
        let(:destroyed_sharelink_data) do
          {
            'access_link' => 'https://dialpad.com/callreview/testLinkId123456789',
            'call_id' => '1234567890123456',
            'id' => 'testLinkId123456789',
            'privacy' => 'company'
          }
        end

        it 'destroys a call review sharelink' do
          stub_request(:delete, "#{base_url}/callreviewsharelink/test123")
            .with(headers: { 'Authorization' => "Bearer #{token}" })
            .to_return(status: 200, body: destroyed_sharelink_data.to_json, headers: { 'Content-Type' => 'application/json' })

          sharelink = described_class.destroy('test123')

          expect(sharelink).to be_a(described_class)
          expect(sharelink.id).to eq('testLinkId123456789')
          expect(sharelink.access_link).to eq('https://dialpad.com/callreview/testLinkId123456789')
        end
      end

      context 'with invalid ID' do
        it 'raises RequiredAttributeError when ID is nil' do
          expect { described_class.destroy(nil) }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end

        it 'raises RequiredAttributeError when ID is empty' do
          expect { described_class.destroy('') }.to raise_error(
            Dialpad::CallReviewSharelink::RequiredAttributeError,
            'Missing required attribute: ID'
          )
        end
      end
    end
  end

  describe 'instance methods' do
    let(:sharelink_attributes) do
      {
        access_link: 'https://dialpad.com/callreview/testLinkId123456789',
        call_id: '1234567890123456',
        id: 'testLinkId123456789',
        privacy: 'company'
      }
    end

    let(:sharelink) { described_class.new(sharelink_attributes) }

    describe '#initialize' do
      it 'sets attributes from hash' do
        expect(sharelink.id).to eq('testLinkId123456789')
        expect(sharelink.access_link).to eq('https://dialpad.com/callreview/testLinkId123456789')
        expect(sharelink.call_id).to eq('1234567890123456')
        expect(sharelink.privacy).to eq('company')
      end

      it 'converts string keys to symbols' do
        sharelink_with_string_keys = described_class.new(
          'id' => 'testLinkId123456789',
          'access_link' => 'https://dialpad.com/callreview/test',
          'privacy' => 'public'
        )

        expect(sharelink_with_string_keys.id).to eq('testLinkId123456789')
        expect(sharelink_with_string_keys.access_link).to eq('https://dialpad.com/callreview/test')
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
        expect(sharelink).to respond_to(:id)
        expect(sharelink).to respond_to(:privacy)
      end

      it 'raises NoMethodError for undefined attributes' do
        expect { sharelink.undefined_attribute }.to raise_error(NoMethodError)
      end
    end

    describe 'privacy values' do
      it 'handles company privacy' do
        expect(sharelink.privacy).to eq('company')
      end

      it 'handles public privacy' do
        public_sharelink = described_class.new(sharelink_attributes.merge(privacy: 'public'))
        expect(public_sharelink.privacy).to eq('public')
      end
    end
  end

  describe 'error handling' do
    it 'defines RequiredAttributeError' do
      expect(Dialpad::CallReviewSharelink::RequiredAttributeError).to be < Dialpad::DialpadObject::RequiredAttributeError
    end
  end

  describe 'API integration' do
    context 'when API returns error' do
      it 'handles 404 errors gracefully' do
        stub_request(:get, "#{base_url}/callreviewsharelink/nonexistent")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 404, body: 'Not Found')

        expect { described_class.retrieve('nonexistent') }.to raise_error(Dialpad::APIError, /404 - Not Found/)
      end

      it 'handles 401 errors gracefully' do
        stub_request(:get, "#{base_url}/callreviewsharelink/test123")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 401, body: 'Unauthorized')

        expect { described_class.retrieve('test123') }.to raise_error(Dialpad::APIError, /401 - Unauthorized/)
      end

      it 'handles 422 errors for create with invalid data' do
        stub_request(:post, "#{base_url}/callreviewsharelink")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 422, body: 'Unprocessable Entity')

        expect { described_class.create({ call_id: 'test', privacy: 'company' }) }.to raise_error(Dialpad::APIError, /422 - Unprocessable Entity/)
      end

      it 'handles 422 errors for update with invalid data' do
        stub_request(:put, "#{base_url}/callreviewsharelink/test123")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 422, body: 'Unprocessable Entity')

        expect { described_class.update('test123', { privacy: 'invalid' }) }.to raise_error(Dialpad::APIError, /422 - Unprocessable Entity/)
      end
    end
  end
end
