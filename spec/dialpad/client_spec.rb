require 'spec_helper'

RSpec.describe Dialpad::Client do
  let(:base_url) { 'https://api.dialpad.com' }
  let(:token) { 'test_token' }
  let(:client) { described_class.new(base_url: base_url, token: token) }

  describe '#initialize' do
    it 'raises error when base_url is nil' do
      expect { described_class.new(base_url: nil, token: token) }.to raise_error(Dialpad::ConfigurationError)
    end

    it 'raises error when base_url is empty' do
      expect { described_class.new(base_url: '', token: token) }.to raise_error(Dialpad::ConfigurationError)
    end

    it 'raises error when token is nil' do
      expect { described_class.new(base_url: base_url, token: nil) }.to raise_error(Dialpad::ConfigurationError)
    end

    it 'raises error when token is empty' do
      expect { described_class.new(base_url: base_url, token: '') }.to raise_error(Dialpad::ConfigurationError)
    end
  end

  describe '#get' do
    it 'makes a GET request' do
      stub_request(:get, "#{base_url}/test")
        .with(headers: { 'Authorization' => "Bearer #{token}" })
        .to_return(status: 200, body: { 'id' => 1, 'name' => 'test' }.to_json, headers: { 'Content-Type' => 'application/json' })

      response = client.get('/test')
      expect(response['id']).to eq(1)
      expect(response['name']).to eq('test')
    end
  end

  describe '#post' do
    it 'makes a POST request' do
      stub_request(:post, "#{base_url}/test")
        .with(
          headers: { 'Authorization' => "Bearer #{token}" },
          body: { 'name' => 'test' }.to_json
        )
        .to_return(status: 201, body: { 'id' => 1, 'name' => 'test' }.to_json, headers: { 'Content-Type' => 'application/json' })

      response = client.post('/test', { 'name' => 'test' })
      expect(response['id']).to eq(1)
      expect(response['name']).to eq('test')
    end
  end

  describe '#put' do
    it 'makes a PUT request' do
      stub_request(:put, "#{base_url}/test/1")
        .with(
          headers: { 'Authorization' => "Bearer #{token}" },
          body: { 'name' => 'updated' }.to_json
        )
        .to_return(status: 200, body: { 'id' => 1, 'name' => 'updated' }.to_json, headers: { 'Content-Type' => 'application/json' })

      response = client.put('/test/1', { 'name' => 'updated' })
      expect(response['id']).to eq(1)
      expect(response['name']).to eq('updated')
    end
  end

  describe '#delete' do
    it 'makes a DELETE request' do
      stub_request(:delete, "#{base_url}/test/1")
        .with(headers: { 'Authorization' => "Bearer #{token}" })
        .to_return(status: 204, body: '')

      response = client.delete('/test/1')
      expect(response).to eq('')
    end
  end

  describe 'error handling' do
    it 'raises APIError for 400 status' do
      stub_request(:get, "#{base_url}/test")
        .to_return(status: 400, body: 'Bad Request')

      expect { client.get('/test') }.to raise_error(Dialpad::APIError, /Bad Request/)
    end

    it 'raises APIError for 401 status' do
      stub_request(:get, "#{base_url}/test")
        .to_return(status: 401, body: 'Unauthorized')

      expect { client.get('/test') }.to raise_error(Dialpad::APIError, /Unauthorized/)
    end

    it 'raises APIError for 404 status' do
      stub_request(:get, "#{base_url}/test")
        .to_return(status: 404, body: 'Not Found')

      expect { client.get('/test') }.to raise_error(Dialpad::APIError, /Not Found/)
    end
  end
end
