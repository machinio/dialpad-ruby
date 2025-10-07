module Dialpad
  class Webhook < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

    ATTRIBUTES = %i(
      hook_url
      id
      signature
    ).freeze

    class << self
      include Validations

      # https://developers.dialpad.com/reference/webhooksget
      def retrieve(id = nil)
        validate_required_attribute(id, "ID")

        data = Dialpad.client.get("webhooks/#{id}")
        new(data)
      end

      # https://developers.dialpad.com/reference/webhookslist
      def list(params = {})
        data = Dialpad.client.get('webhooks', params)
        return [] if data['items'].nil?

        data['items'].map { |item| new(item) }
      end

      # https://developers.dialpad.com/reference/webhookscreate
      def create(attributes)
        validate_required_attributes(attributes, [:hook_url])

        data = Dialpad.client.post('webhooks', attributes)
        new(data)
      end

      # https://developers.dialpad.com/reference/webhookupdate
      def update(id = nil, attributes = {})
        validate_required_attribute(id, "ID")

        data = Dialpad.client.patch("webhooks/#{id}", attributes)
        new(data)
      end

      # https://developers.dialpad.com/reference/webhooksdelete
      def destroy(id = nil)
        validate_required_attribute(id, "ID")

        data = Dialpad.client.delete("webhooks/#{id}")
        new(data)
      end
    end
  end
end
