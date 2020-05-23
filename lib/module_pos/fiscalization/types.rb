require "dry-types"

module ModulePos::Fiscalization
  class Types
    include Dry.Types()

    PosStatus = Types::String.enum('READY', 'ASSOCIATED', 'FAILED')

    DocStatus = Types::String.enum(
      'QUEUED', 'PENDING', 'PRINTED', 'WAIT_FOR_CALLBACK', 'COMPLETED', 'FAILED'
    )

    PaymentMethod = Types::Coercible::String.enum(
      'full_prepayment', 'prepayment', 'advance', 'full_payment', 'partial_payment', 'credit',
      'credit_payment'
    )
    PaymentObject = Types::Coercible::String.enum(
      'commodity', 'excise', 'job', 'service', 'gambling_bet', 'gambling_prize', 'lottery',
      'lottery_prize', 'intellectual_activity', 'payment', 'agent_commission', 'composite',
      'another', 'property_right', 'non-operating_gain', 'insurance_premium', 'sales_tax',
      'resort_fee'
    )
    VatTag = Types::Integer.enum(
      1104 => :zero,
      1103 => :percent10,
      1102 => :percent20,
      1105 => :no_tax,
      1107 => :delay10,
      1106 => :delay20
    )
    PaymentType = Types::String.enum('CARD', 'CASH', 'PREPAID', 'POSTPAY', 'OTHER')
    AgentType = Types::Coercible::String.enum(
      'bank_paying_agent', 'bank_paying_subagent', 'paying_agent', 'paying_subagent', 'attorney',
      'commission_agent', 'another'
    )
    DocType = Types::String.enum('SALE', 'RETURN', 'BUY', 'BUY_RETURN')
    TaxMode = Types::String.enum(
      'COMMON', 'SIMPLIFIED', 'SIMPLIFIED_WITH_EXPENSE', 'ENVD', 'PATENT', 'COMMON_AGRICULTURAL'
    )
    Email = Types::String.constrained(format: /^.*@.*$/)
    TaxId = Types::Coercible::String.constrained(format: /^[0-9]{10,12}$/)
  end
end
