module ModulePos::Fiscalization
  module Entities
    class Position < Base
      class SupplierInfo < Base
        attribute? :phones, Types::Array.of(Types::Coercible::String)
        attribute? :name, Types::String.constrained(max_size: 255)
        attribute? :inn, Types::TaxId
      end

      attribute :name, Types::String.constrained(max_size: 128)
      attribute :price, ModulePos::Fiscalization::Types::Coercible::Decimal
      attribute :quantity, ModulePos::Fiscalization::Types::Coercible::Decimal
      attribute :vat_tag, Types::VatTag

      attribute? :barcode, Types::Coercible::String
      attribute? :product_mark, Types::String.constrained(max_size: 255)
      attribute? :nomenclature_code, Types::String
      attribute? :vat_sum, Types::String
      attribute? :payment_object, Types::PaymentObject
      attribute? :payment_method, Types::PaymentMethod
      attribute? :disc_sum, ModulePos::Fiscalization::Types::Coercible::Decimal
      attribute? :origin_country_code, Types::Integer
      attribute? :customs_declaration_number, Types::String.constrained(max_size: 32)
      attribute? :agent_info, AgentInfo
      attribute? :supplier_info, SupplierInfo
    end
  end
end
