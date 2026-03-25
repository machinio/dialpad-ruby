module Dialpad
  class CallReviewSharelink < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

    ATTRIBUTES = %i(
      access_link
      call_id
      id
      privacy
    ).freeze

    # privacy: (company public)

    class << self
      include Validations

      # https://developers.dialpad.com/reference/call_review_share_linkget
      def retrieve(id = nil)
        validate_required_attribute(id, "ID")

        response = Dialpad.client.get("callreviewsharelink/#{id}")
        new(response.body)
      end

      # https://developers.dialpad.com/reference/call_review_share_linkcreate
      def create(attributes = {})
        validate_required_attributes(attributes, %i(call_id privacy))

        response = Dialpad.client.post('callreviewsharelink', attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/call_review_share_linkupdate
      def update(id = nil, attributes = {})
        validate_required_attribute(id, "ID")
        validate_required_attributes(attributes, %i(privacy))

        response = Dialpad.client.put("callreviewsharelink/#{id}", attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/call_review_share_linkdelete
      def destroy(id = nil)
        validate_required_attribute(id, "ID")

        response = Dialpad.client.delete("callreviewsharelink/#{id}")
        new(response.body)
      end
    end
  end
end
