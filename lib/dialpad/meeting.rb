module Dialpad
  class Meeting < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

    ATTRIBUTES = %i(
      call_out
      dial_in_number
      duration
      end_datetime
      id
      instance_id
      is_moderated
      meeting_type
      meeting_url
      organizer_pin
      participant_pin
      participants_info
      recurrence
      recurrence_end_date
      start_datetime
      timezone
      title
    ).freeze

    class << self
      include Validations

      # https://developers.dialpad.com/reference/meetingsget
      def retrieve(scheduled_conference_id = nil)
        validate_required_attribute(id, "ID")

        response = Dialpad.client.get("meetings/#{scheduled_conference_id}")
        new(response.body)
      end

      # https://developers.dialpad.com/reference/meetingslist
      def list(params = {})
        response = Dialpad.client.get('meetings', params)
        paginated_response_from(response)
      end

      # https://developers.dialpad.com/reference/meetingscreate
      def create(attributes = {})
        validate_required_attributes(attributes, %i(end_datetime meeting_type start_datetime title user_id))

        response = Dialpad.client.post('meetings', attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/meetingsupdate
      def update(scheduled_conference_id = nil, attributes = {})
        validate_required_attributes(attributes, %i(end_datetime meeting_type start_datetime title user_id))

        response = Dialpad.client.put("meetings/#{scheduled_conference_id}", attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/meetingsdelete
      def destroy(scheduled_conference_id = nil)
        validate_required_attribute(scheduled_conference_id, "Scheduled Conference ID")

        response = Dialpad.client.delete("meetings/#{scheduled_conference_id}")
        new(response.body)
      end
    end
  end
end
