require "dry-struct"

module ModulePos::Fiscalization
  module Entities
    class AgentInfo < Base
      class Agent < Base
        attribute? :operation, Types::String.constrained(max_size: 24)
        attribute? :phones, Types::Array.of(Types::Coercible::String)
      end

      class PaymentsOperator < Base
        attribute? :phones, Types::Array.of(Types::Coercible::String)
      end

      class TransferOperator < Base
        attribute? :phones, Types::Array.of(Types::Coercible::String)
        attribute? :name, Types::String.constrained(max_size: 64)
        attribute? :address, Types::String.constrained(max_size: 255)
        attribute? :inn, Types::TaxId
      end

      attribute? :types, Types::Array.of(Types::AgentType)
      attribute? :paying_agent, Agent
      attribute? :money_transfer_operator, TransferOperator
      attribute? :receive_payments_operator, PaymentsOperator
    end
  end
end
