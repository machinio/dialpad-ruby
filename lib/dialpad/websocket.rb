module Dialpad
  class Websocket < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end
    ATTRIBUTES = %i(
      id
      signature
      websocket_url
    ).freeze

    class << self
      include Validations

      def create(attributes = {})
        response = Dialpad.client.post('websockets', attributes)
        new(response.body)
      end

      def destroy(id)
        response = Dialpad.client.delete("websockets/#{id}")
        new(response.body)
      end
    end
  end
end
