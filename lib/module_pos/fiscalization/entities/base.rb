require "dry-struct"

module ModulePos::Fiscalization
  module Entities
    class Base < Dry::Struct
      transform_keys ->(key) {
        key.to_s
           .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2')
           .tr('-', '_')
           .gsub(/\s/, '_')
           .gsub(/__+/, '_')
           .downcase
           .to_sym
      }

      # Return camelize hash for request
      # @return [Hash]
      def as_json(*)
        ApiUtils.camelize_keys attributes, ->(val) {
          case val
          when Base
            val.as_json
          when BigDecimal
            val.to_f
          else
            val
          end
        }
      end
    end
  end
end

