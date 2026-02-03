module Dialpad
  module Subscriptions
    class SmsEvent < DialpadObject
      class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

      ATTRIBUTES = %i(
        direction
        enabled
        id
        include_internal
        status
        target_id
        target_type
        webhook
        websocket
      ).freeze

      # target_type is one of (callcenter callrouter channel coachinggroup coachingteam department office room staffgroup unknown user)
      # direction is one of (all inbound outbound)

      # Response might contain webhook or websocket object
      def webhook
        attributes[:webhook]
      end

      def websocket
        attributes[:websocket]
      end

      class << self
        include Validations

        # https://developers.dialpad.com/reference/webhook_sms_event_subscriptionget
        def retrieve(id = nil)
          validate_required_attribute(id, "ID")
          response = Dialpad.client.get("subscriptions/sms/#{id}")
          new(response.body)
        end

        # https://developers.dialpad.com/reference/webhook_sms_event_subscriptionlist
        def list(params = {})
          response = Dialpad.client.get('subscriptions/sms', params)
          paginated_response_from(response)
        end

        # https://developers.dialpad.com/reference/webhook_sms_event_subscriptioncreate
        def create(attributes = {})
          validate_required_attributes(attributes, [:webhook_id])

          response = Dialpad.client.post('subscriptions/sms', attributes)
          new(response.body)
        end

        # https://developers.dialpad.com/reference/webhook_sms_event_subscriptionupdate
        def update(id = nil, attributes = {})
          response = Dialpad.client.patch("subscriptions/sms/#{id}", attributes)
          new(response.body)
        end

        # https://developers.dialpad.com/reference/webhook_sms_event_subscriptiondelete
        def destroy(id = nil)
          validate_required_attribute(id, "ID")

          response = Dialpad.client.delete("subscriptions/sms/#{id}")
          new(response.body)
        end
      end
    end
  end
end
