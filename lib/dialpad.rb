require 'dialpad/version'
require 'dialpad/client'
require 'dialpad/validations'
require 'dialpad/dialpad_object'
require 'dialpad/webhook'
require 'dialpad/subscriptions/call_event'
require 'dialpad/subscriptions/contact_event'
require 'dialpad/contact'
require 'dialpad/call'

module Dialpad
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class APIError < Error; end

  class << self
    attr_writer :base_url, :token

    def configure
      yield self
    end

    def base_url
      @base_url ||= ENV.fetch('DIALPAD_API_BASE_URL', 'https://dialpad.com/api/v2')
    end

    def token
      @token || ENV['DIALPAD_API_TOKEN']
    end

    def client
      @client ||= Client.new(base_url: base_url, token: token)
    end
  end
end
