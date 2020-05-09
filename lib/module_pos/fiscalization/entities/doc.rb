module ModulePos::Fiscalization
  module Entities
    class Doc < Base
      class MoneyPosition < Base
        attribute :payment_type, Types::PaymentType
        attribute :sum, ModulePos::Fiscalization::Types::Coercible::Decimal
      end

      attribute :id, Types::Coercible::String
      attribute :checkout_date_time, Types::JSON::DateTime
      attribute :doc_num, Types::Coercible::String
      attribute :doc_type, Types::DocType
      attribute :email, Types::Email
      attribute :money_positions, Types::Array.of(MoneyPosition)
      attribute :invent_positions, Types::Array.of(Position)

      attribute? :print_receipt, Types::Strict::Bool
      attribute? :text_to_print, Types::Coercible::String
      attribute? :cashier_name, Types::Coercible::String
      attribute? :cashier_inn, Types::TaxId
      attribute? :cashier_position, Types::String.constrained(max_size: 64)
      attribute? :response_url, Types::String
      attribute? :tax_mode, Types::TaxMode
      attribute? :client_name, Types::String
      attribute? :client_inn, Types::TaxId
      attribute? :agent_info, AgentInfo
    end
  end
end
