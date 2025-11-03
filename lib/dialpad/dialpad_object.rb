module Dialpad
  class DialpadObject
    class RequiredAttributeError < Dialpad::APIError; end

    attr_reader :attributes

    def initialize(attributes = {})
      @attributes =
        attributes.each_with_object({}) do |(key, value), hash|
          hash[key.to_sym] = value
        end
    end

    def method_missing(method, *args)
      if self.class::ATTRIBUTES.include?(method)
        @attributes[method]
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      self.class::ATTRIBUTES.include?(method) || super
    end

    def update(attributes)
      self.class.update(id, attributes)
    end

    def destroy
      self.class.destroy(id)
    end
  end
end
