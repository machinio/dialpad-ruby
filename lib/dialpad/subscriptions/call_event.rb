module Dialpad
  module Subscriptions
    class CallEvent < DialpadObject
      class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

      ATTRIBUTES = %i(
        call_states
        enabled
        group_calls_only
        id
        webhook
      ).freeze

      class << self
        include Validations

        # https://developers.dialpad.com/reference/webhook_call_event_subscriptionget
        def retrieve(id = nil)
          validate_required_attribute(id, "ID")

          data = Dialpad.client.get("subscriptions/call/#{id}")
          new(data)
        end

        # https://developers.dialpad.com/reference/webhook_call_event_subscriptionlist
        def list(params = {})
          data = Dialpad.client.get('subscriptions/call', params)
          return [] if data['items'].nil? || data['items'].empty?

          data['items'].map { |item| new(item) }
        end

        # https://developers.dialpad.com/reference/webhook_call_event_subscriptioncreate
        def create(attributes = {})
          validate_required_attributes(attributes, [:webhook_id])

          data = Dialpad.client.post('subscriptions/call', attributes)
          new(data)
        end

        # https://developers.dialpad.com/reference/webhook_call_event_subscriptionupdate
        def update(id = nil, attributes = {})
          data = Dialpad.client.patch("subscriptions/call/#{id}", attributes)
          new(data)
        end

        # https://developers.dialpad.com/reference/webhook_call_event_subscriptiondelete
        def destroy(id = nil)
          validate_required_attribute(id, "ID")

          data = Dialpad.client.delete("subscriptions/call/#{id}")
          new(data)
        end
      end
    end
  end
end
