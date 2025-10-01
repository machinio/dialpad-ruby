module Dialpad
  class Call < DialpadObject
    class RequiredAttributeError < StandardError; end

    ATTRIBUTES = %i(
      admin_call_recording_share_links
      call_id
      call_recording_share_links
      contact
      csat_recording_urls
      csat_score
      csat_transcriptions
      custom_data
      date_connected
      date_ended
      date_rang
      date_started
      direction
      duration
      entry_point_call_id
      entry_point_target
      event_timestamp
      external_number
      group_id
      internal_number
      is_transferred
      labels
      master_call_id
      mos_score
      operator_call_id
      proxy_target
      recording_details
      routing_breadcrumbs
      screen_recording_urls
      state
      target
      total_duration
      transcription_text
      voicemail_share_link
      was_recorded
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
