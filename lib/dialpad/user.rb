module Dialpad
  class User < DialpadObject
    ATTRIBUTES = %i(
      admin_office_ids
      company_id
      country
      date_active
      date_added
      date_first_login
      display_name
      do_not_disturb
      emails
      first_name
      id
      image_url
      international_dialing_enabled
      is_admin
      is_available
      is_on_duty
      is_online
      is_super_admin
      language
      last_name
      license
      muted
      office_id
      onboarding_completed
      phone_numbers
      state
      timezone
      voicemail
    ).freeze

    class << self
      include Validations

      # https://developers.dialpad.com/reference/userslist
      def list(params = {})
        data = Dialpad.client.get('users', params)
        return [] if data['items'].nil?

        data['items'].map { |item| new(item) }
      end

      # https://developers.dialpad.com/reference/usersget
      def retrieve(id = nil)
        validate_required_attribute(id, "ID")

        data = Dialpad.client.get("users/#{id}")
        new(data)
      end

      # https://developers.dialpad.com/reference/userscreate
      def create(attributes = {})
        validate_required_attributes(attributes, %i(email office_id))

        data = Dialpad.client.post('users', attributes)
        new(data)
      end

      # https://developers.dialpad.com/reference/usersupdate
      def update(id = nil, attributes = {})
        validate_required_attribute(id, "ID")

        data = Dialpad.client.patch("users/#{id}", attributes)
        new(data)
      end

      # https://developers.dialpad.com/reference/usersdelete
      def destroy(id = nil)
        validate_required_attribute(id, "ID")

        data = Dialpad.client.delete("users/#{id}")
        new(data)
      end
    end
  end
end
