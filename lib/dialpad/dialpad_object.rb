module Dialpad
  class DialpadObject
    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes.transform_keys(&:to_sym)
    end

    def method_missing(method, *args)
      @attributes.key?(method) ? @attributes[method] : super
    end

    def respond_to_missing?(method, include_private = false)
      @attributes.key?(method) || super
    end
  end
end
