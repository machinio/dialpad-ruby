module Dialpad
  class Call < DialpadObject
    class RequiredAttributeError < StandardError; end

    ATTRIBUTES = %i(
      date_started
      call_id
      state
      direction
      external_number
      internal_number
      date_rang
      date_first_rang
      date_queued
      target_availability_status
      callback_requested
      date_connected
      date_ended
      talk_time
      hold_time
      duration
      total_duration
      contact
      target
      entry_point_call_id
      entry_point_target
      operator_call_id
      proxy_target
      group_id
      master_call_id
      is_transferred
      csat_score
      routing_breadcrumbs
      event_timestamp
      mos_score
      labels
      was_recorded
      voicemail_link
      voicemail_recording_id
      call_recording_ids
      transcription_text
      recording_details
      integrations
      controller
      action
    ).freeze

    class << self
      include Validations

      # https://developers.dialpad.com/reference/callget_call_info
      def retrieve(id = nil)
        validate_required_attribute(id, "ID")

        data = Dialpad.client.get("call/#{id}")
        new(data)
      end

      # https://developers.dialpad.com/reference/calllist
      def list(params = {})
        data = Dialpad.client.get('call', params)
        return [] if data['items'].blank?

        data['items'].map { |item| new(item) }
      end
    end
  end
end
