module Dialpad
  class Contact < DialpadObject
    class RequiredAttributeError < Dialpad::DialpadObject::RequiredAttributeError; end

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

        data = Dialpad.client.get("contacts/#{id}")
        new(data)
      end

      # https://developers.dialpad.com/reference/contactslist
      def list(params = {})
        data = Dialpad.client.get('contacts', params)
        return [] if data['items'].nil? || data['items'].empty?

        data['items'].map { |item| new(item) }
      end

      # https://developers.dialpad.com/reference/contactscreate
      def create(attributes = {})
        validate_required_attributes(attributes, %i(first_name last_name))

        data = Dialpad.client.post('contacts', attributes)
        new(data)
      end

      # https://developers.dialpad.com/reference/contactscreate_with_uid
      def create_or_update(attributes = {})
        validate_required_attributes(attributes, %i(first_name last_name uid))

        data = Dialpad.client.put('contacts', attributes)
        new(data)
      end

      # https://developers.dialpad.com/reference/contactsupdate
      def update(id = nil, attributes = {})
        validate_required_attribute(id, "ID")

        data = Dialpad.client.patch("contacts/#{id}", attributes)
        new(data)
      end

      # https://developers.dialpad.com/reference/contactsdelete
      def destroy(id = nil)
        validate_required_attribute(id, "ID")

        data = Dialpad.client.delete("contacts/#{id}")
        new(data)
      end
    end
  end
end
