require 'json'

module ModulePos::Fiscalization
  class JsonRequest
    InvalidResponse = Class.new(StandardError)

    def call(user = nil, pass = nil)
      @conn.basic_auth(user, pass) if user && pass
      response = yield @conn
      JSON.parse!(response.body).compact unless response.body.empty?
    rescue JSON::ParserError
      raise InvalidResponse
    end

    private

    def initialize(conn)
      @conn = conn
    end
  end
end
