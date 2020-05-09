require 'api_utils'
require "module_pos/fiscalization/version"
require "module_pos/fiscalization/types"
require "module_pos/fiscalization/json_request"
require "module_pos/fiscalization/connection"
require "module_pos/fiscalization/client"
require "module_pos/fiscalization/entities/base"
require "module_pos/fiscalization/entities/secret"
require "module_pos/fiscalization/entities/agent_info"
require "module_pos/fiscalization/entities/position"
require "module_pos/fiscalization/entities/doc"
require "module_pos/fiscalization/entities/doc_status"
require "module_pos/fiscalization/entities/pos_status"

module ModulePos
  module Fiscalization
    module Doc
      module_function

      def create(args)
        Entities::Doc.new(args)
      end
    end
  end
end
