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
        data = Dialpad.client.post('websockets', attributes)
        new(data)
      end

      def destroy(id)
        data = Dialpad.client.delete("websockets/#{id}")
        new(data)
      end
    end
  end
end
