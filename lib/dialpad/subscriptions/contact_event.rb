module Dialpad
  module Subscriptions
    class ContactEvent < DialpadObject
      class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

      ATTRIBUTES = %i(
        contact_type
        enabled
        id
        webhook
        websocket
      ).freeze

      class << self
        include Validations

        # https://developers.dialpad.com/reference/webhook_contact_event_subscriptionget
        def retrieve(id = nil)
          validate_required_attribute(id, "ID")

          data = Dialpad.client.get("subscriptions/contact/#{id}")
          new(data)
        end

        # https://developers.dialpad.com/reference/webhook_contact_event_subscriptionlist
        def list(params = {})
          data = Dialpad.client.get('subscriptions/contact', params)
          return [] if data['items'].nil? || data['items'].empty?

          data['items'].map { |item| new(item) }
        end

        # https://developers.dialpad.com/reference/webhook_contact_event_subscriptioncreate
        def create(attributes = {})
          validate_required_attributes(attributes, [:webhook_id])

          data = Dialpad.client.post('subscriptions/contact', attributes)
          new(data)
        end

        # https://developers.dialpad.com/reference/webhook_contact_event_subscriptionupdate
        def update(id = nil, attributes = {})
          validate_required_attribute(id, "ID")

          data = Dialpad.client.patch("subscriptions/contact/#{id}", attributes)
          new(data)
        end

        # https://developers.dialpad.com/reference/webhook_contact_event_subscriptiondelete
        def destroy(id = nil)
          validate_required_attribute(id, "ID")

          data = Dialpad.client.delete("subscriptions/contact/#{id}")
          new(data)
        end
      end
    end
  end
end
