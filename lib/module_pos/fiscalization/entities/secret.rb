module ModulePos::Fiscalization
  module Entities
    # Credentials for protect api methods
    # :user_name - [String]
    # :password - [String]
    # :name - [String]
    # :address - [String]
    class Secret < Base
      attribute :user_name, Types::String
      attribute :password, Types::String
      attribute? :name, Types::String
      attribute? :address, Types::String
    end
  end
end
