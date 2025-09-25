require 'faraday'

module Dialpad
  class Client
    attr_reader :base_url, :token

    def initialize(base_url:, token:)
      raise ConfigurationError, 'Base URL is required' if base_url.nil? || base_url.empty?
      raise ConfigurationError, 'Token is required' if token.nil? || token.empty?

      @base_url = base_url
      @token = token
    end

    def connection
      @connection ||=
        Faraday.new(url: base_url) do |conn|
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
          conn.headers['Authorization'] = "Bearer #{token}"
          conn.headers['Content-Type'] = 'application/json'
          conn.headers['Accept'] = 'application/json'
        end
    end

    def get(path, params = {})
      response = connection.get(path, params)
      handle_response(response)
    end

    def post(path, body = {})
      response = connection.post(path, body)
      handle_response(response)
    end

    def put(path, body = {})
      response = connection.put(path, body)
      handle_response(response)
    end

    def patch(path, body = {})
      response = connection.patch(path, body)
      handle_response(response)
    end

    def delete(path)
      response = connection.delete(path)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.status
      when 200..299
        response.body
      else
        body = response.body.is_a?(Hash) ? response.body.dig('error', 'message') : response.body
        raise APIError, "#{response.status} - #{body}"
      end
    end
  end
end
