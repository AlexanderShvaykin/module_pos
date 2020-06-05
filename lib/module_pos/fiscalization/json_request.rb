require 'json'

module ModulePos::Fiscalization
  class JsonRequest
    InvalidResponse = Class.new(StandardError)

    def call(user = nil, pass = nil)
      @conn.basic_auth(user, pass) if user && pass
      response = yield @conn
      if response.status.to_s.match?(/2[0-9][0-9]/)
        JSON.parse!(response.body).compact unless response.body.empty?
      else
        raise ResponseError, "Status: #{response.status} Response: #{response.body}"
      end
    rescue JSON::ParserError
      raise InvalidResponse
    end

    private

    def initialize(conn, logger = nil)
      @conn = conn
      @conn.response(:logger, logger) if logger
    end
  end
end
