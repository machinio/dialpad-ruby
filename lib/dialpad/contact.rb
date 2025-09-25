module Dialpad
  class Contact
    class RequiredAttributeError < StandardError; end

    ATTRIBUTES = %i(
      company_name
      display_name
      emails
      extension
      first_name
      id
      job_title
      last_name
      owner_id
      phones
      primary_email
      primary_phone
      trunk_group
      type
      urls
    ).freeze

    class << self
      include Validations

      # https://developers.dialpad.com/reference/contactsget
      def retrieve(id = nil)
        validate_required_attribute(id, "ID")

        Dialpad.client.get("contacts/#{id}")
      end

      # https://developers.dialpad.com/reference/contactslist
      def list(params = {})
        Dialpad.client.get('contacts', params)
      end

      # https://developers.dialpad.com/reference/contactscreate
      def create(attributes = {})
        validate_required_attributes(attributes, %i(first_name last_name))

        Dialpad.client.post('contacts', attributes)
      end

      # https://developers.dialpad.com/reference/contactscreate_with_uid
      def create_or_update(attributes = {})
        validate_required_attributes(attributes, %i(first_name last_name uid))

        Dialpad.client.put('contacts', attributes)
      end

      # https://developers.dialpad.com/reference/contactsupdate
      def update(id = nil, attributes = {})
        validate_required_attribute(id, "ID")

        Dialpad.client.patch("contacts/#{id}", attributes)
      end

      # https://developers.dialpad.com/reference/contactsdelete
      def destroy(id = nil)
        validate_required_attribute(id, "ID")

        Dialpad.client.delete("contacts/#{id}")
      end
    end
  end
end
