module Dialpad
  class Sms < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

    ATTRIBUTES = %i(
      contact
      contact_id
      created_date
      device_type
      direction
      event_timestamp
      from_number
      id
      is_internal
      message_delivery_result
      message_status
      mms
      mms_url
      sender_id
      target
      text
      text_content
      to_number
    ).freeze

    def to_numbers
      attributes[:to_numbers] || attributes[:to_number] || []
    end

    def contact_id
      attributes[:contact_id] || contact && contact[:id]
    end

    def target_id
      attributes[:target_id] || target && target[:id]
    end

    def target_type
      attributes[:target_type] || target && target[:type]
    end

    class << self
      # https://developers.dialpad.com/reference/smssend

      # Attributes:
      #
      # channel_hashtag: string | null
      # from_number: string | null
      # infer_country_code: boolean | null (Defaults to false)
      # media: string | null (Base64-encoded media attachment (will cause the message to be sent as MMS). (Max 500 KiB raw file size))
      # sender_group_id: int64 | null
      # sender_group_type: string | null, Allowed: (callcenter, department, office)
      # text: string | null
      # to_numbers: array of strings | null
      # user_id: int64 | null

      def send(attributes = {})
        response = Dialpad.client.post('sms', attributes)
        new(response.body)
      end
    end
  end
end
