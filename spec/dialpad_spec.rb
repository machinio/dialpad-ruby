require 'spec_helper'

RSpec.describe Dialpad do
  describe '.configure' do
    it 'allows configuration of base_url and token' do
      Dialpad.configure do |config|
        config.base_url = 'https://api.dialpad.com'
        config.token = 'test_token'
      end

      expect(Dialpad.base_url).to eq('https://api.dialpad.com')
      expect(Dialpad.token).to eq('test_token')
    end
  end

  describe '.base_url' do
    it 'returns configured base_url' do
      Dialpad.base_url = 'https://api.dialpad.com'
      expect(Dialpad.base_url).to eq('https://api.dialpad.com')
    end

    it 'falls back to environment variable' do
      ENV['DIALPAD_API_BASE_URL'] = 'https://env.dialpad.com'
      expect(Dialpad.base_url).to eq('https://env.dialpad.com')
    end
  end

  describe '.token' do
    it 'returns configured token' do
      Dialpad.token = 'configured_token'
      expect(Dialpad.token).to eq('configured_token')
    end

    it 'falls back to environment variable' do
      ENV['DIALPAD_API_TOKEN'] = 'env_token'
      expect(Dialpad.token).to eq('env_token')
    end
  end

  describe '.client' do
    it 'returns a client instance' do
      Dialpad.base_url = 'https://api.dialpad.com'
      Dialpad.token = 'test_token'

      expect(Dialpad.client).to be_a(Dialpad::Client)
    end
  end
end
