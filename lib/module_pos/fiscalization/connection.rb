require 'faraday'
require 'delegate'

module ModulePos::Fiscalization
  class Connection < Delegator
    private

    def __getobj__
      @conn
    end

    def initialize(host)
      @conn = Faraday.new(
        url: host,
        headers: {'Content-Type' => 'application/json'}
      )
    end
  end
end
