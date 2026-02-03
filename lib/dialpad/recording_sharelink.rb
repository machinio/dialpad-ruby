module Dialpad
  class RecordingSharelink < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

    ATTRIBUTES = %i(
      access_link
      call_id
      created_by_id
      date_added
      id
      item_id
      privacy
      type
    ).freeze

    # privacy: (admin company owner public)
    # type: (admincallrecording callrecording voicemail)

    class << self
      include Validations

      # https://developers.dialpad.com/reference/recording_share_linkget
      def retrieve(id = nil)
        validate_required_attribute(id, "ID")

        response = Dialpad.client.get("recordingsharelink/#{id}")
        new(response.body)
      end

      # https://developers.dialpad.com/reference/contactscreate
      def create(attributes = {})
        validate_required_attributes(attributes, %i(recording_id recording_type))

        response = Dialpad.client.post('recordingsharelink', attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/recording_share_linkupdate
      def update(id = nil, attributes = {})
        validate_required_attribute(id, "ID")
        validate_required_attributes(attributes, %i(privacy))

        response = Dialpad.client.put("recordingsharelink/#{id}", attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/recording_share_linkdelete
      def destroy(id = nil)
        validate_required_attribute(id, "ID")

        response = Dialpad.client.delete("recordingsharelink/#{id}")
        new(response.body)
      end
    end
  end
end
