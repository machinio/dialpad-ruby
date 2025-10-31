module Dialpad
  class Department < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

    ATTRIBUTES = %i(
      auto_call_recording
      availability_status
      country
      first_action
      friday_hours
      group_description
      hold_queue
      hours_on
      id
      monday_hours
      name
      no_operators_action
      office_id
      phone_numbers
      ring_seconds
      routing_options
      saturday_hours
      state
      sunday_hours
      thursday_hours
      timezone
      tuesday_hours
      voice_intelligence
      wednesday_hours
    ).freeze

    def operator_users
      response = Dialpad.client.get("departments/#{id}/operators")
      return [] if response.body['users'].nil?

      response.body['users'].map { |user| User.new(user) }
    end

    class << self
      include Validations

      # https://developers.dialpad.com/reference/departmentsget
      def retrieve(id = nil)
        validate_required_attribute(id, "ID")

        response = Dialpad.client.get("departments/#{id}")
        new(response.body)
      end

      # https://developers.dialpad.com/reference/departmentslistall
      def list(params = {})
        response = Dialpad.client.get('departments', params)
        return [] if response.body['items'].nil?

        response.body['items'].map { |item| new(item) }
      end

      # https://developers.dialpad.com/reference/departmentscreate
      def create(attributes = {})
        validate_required_attributes(attributes, %i(name office_id))

        response = Dialpad.client.post('departments', attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/departmentsupdate
      def update(id = nil, attributes = {})
        validate_required_attribute(id, "ID")

        response = Dialpad.client.patch("departments/#{id}", attributes)
        new(response.body)
      end

      # https://developers.dialpad.com/reference/departmentsdelete
      def destroy(id = nil)
        validate_required_attribute(id, "ID")

        response = Dialpad.client.delete("departments/#{id}")
        new(response.body)
      end
    end
  end
end
