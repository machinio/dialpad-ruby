module Dialpad
  module Validations
    private

    def validate_required_attributes(attributes, required_attrs)
      missing_attrs = required_attrs.reject { |attr| attributes.key?(attr) && !attributes[attr].nil? && !attributes[attr].to_s.empty? }

      if missing_attrs.any?
        raise self::RequiredAttributeError, "Missing required attributes: #{missing_attrs.join(', ')}"
      end
    end

    def validate_required_attribute(attribute = nil, attribute_name)
      if attribute.nil? || attribute.to_s.empty?
        raise self::RequiredAttributeError, "Missing required attribute: #{attribute_name}"
      end
    end
  end
end
