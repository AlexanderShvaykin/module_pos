module ModulePos::Fiscalization
  module Entities
    class PosStatus < Base
      attribute :status, Types::PosStatus
      attribute :date_time, Types::String

      def ready?
        status == "READY"
      end
    end
  end
end

