module ModulePos::Fiscalization
  module Entities
    class DocStatus < Base
      class FiscalInfo < Base
        attribute :shift_number, Types::Coercible::Integer
        attribute :check_number, Types::Coercible::Integer
        attribute :kkt_number, Types::String
        attribute :fn_number, Types::String
        attribute :fn_doc_number, Types::Coercible::Integer
        attribute :fn_doc_mark, Types::Coercible::Integer
        attribute :date, Types::String
        attribute :sum, ModulePos::Fiscalization::Types::Coercible::Decimal
        attribute :check_type, Types::String
        attribute :qr, Types::String
        attribute :ecr_registration_number, Types::String
      end

      class FailureInfo < Base
        attribute :type, Types::String
        attribute :message, Types::String
      end

      attribute :status, Types::DocStatus
      attribute :fn_state, Types::String
      attribute? :fiscal_info, FiscalInfo
      attribute? :failure_info, FailureInfo
      attribute? :message, Types::String
      attribute? :time_status_changed, Types::String

      def failed?
        status == "FAILED"
      end

      def pending?
        status == "PENDING"
      end

      def printed?
        status == "PRINTED"
      end
      alias_method :success?, :printed?

      def completed?
        status == "COMPLETED"
      end
    end
  end
end

