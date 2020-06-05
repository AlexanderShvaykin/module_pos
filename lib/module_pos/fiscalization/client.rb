require "date"
require 'faraday'

module ModulePos::Fiscalization
  # Http client for Module POS api
  class Client
    ASSOCIATE_PATH = "api/fn/v1/associate"
    STATUS_PATH = "api/fn/v1/status"
    DOC_PATH = "/v2/doc"

    module Scopes
      class Base
        def initialize(path, http, pass: nil, username: nil)
          @path = path
          @username = username
          @pass = pass
          @http = http
        end

        private
        attr_reader :path, :username, :pass, :http
      end

      # Associate actions scope
      class Associate < Base
        # @param [String] client_id
        # @return [ModulePos::V1::Entities::Secret]
        def create(client_id: nil)
          resp = http.call do |conn|
            conn.post(path) do |req|
              req.params["clientId"] = client_id if client_id
            end
          end

          ModulePos::Fiscalization::Entities::Secret.new(resp)
        end

        # @return [NilClass]
        # @param [String] username
        # @param [String] password
        def delete(username, password)
          http.call(username, password) { |conn| conn.delete(path) }
          nil
        end
      end

      # Docs actions scope
      class Docs < Base
        # Send doc to modulpose
        # @param [ModulePos::Fiscalization::Entities::Doc] doc
        # @return [ModulePos::Fiscalization::Entities::DocStatus]
        def save(doc)
          resp = http.call(username, pass) do |conn|
            conn.post(path) do |req|
              req.body = doc.as_json
            end
          end

          ModulePos::Fiscalization::Entities::DocStatus.new(resp)
        end

        # @param [String] id
        # @return [ModulePos::Fiscalization::Entities::DocStatus]
        def status(id)
          resp = http.call(username, pass) do |conn|
            conn.get("#{path}/#{id}/status")
          end

          ModulePos::Fiscalization::Entities::DocStatus.new(resp)
        end

        # @param [String] id
        # @return [ModulePos::Fiscalization::Entities::DocStatus]
        def re_queue(id)
          resp = http.call(username, pass) do |conn|
            conn.put("#{path}/#{id}/re-queue")
          end

          ModulePos::Fiscalization::Entities::DocStatus.new(resp)
        end
      end
    end

    # Return associate scope, for actions to associate recourse
    # @param [String] uid
    # @return [ModulePos::V1::Client::Scopes::Associate]
    def associate(uid)
      Scopes::Associate.new("#{ASSOCIATE_PATH}/#{uid}", http)
    end

    # Return associate scope, for actions to doc
    # @return [ModulePos::V1::Client::Scopes::Docs]
    def docs
      Scopes::Docs.new(DOC_PATH, http, username: username, pass: pass)
    end

    # Request POS status, return
    #   { status: "READY|ASSOCIATED|FAILED", date_time: <DateTime> }
    # @return [Hash]
    def status
      res = http.call(username, pass) { |conn| conn.get(STATUS_PATH) }
      ModulePos::Fiscalization::Entities::PosStatus.new(res)
    end

    private

    attr_reader :http, :username, :pass

    def initialize(
      host:,
      username: nil,
      pass: nil,
      conn: Faraday.new(
          url: host,
          headers: {'Content-Type' => 'application/json'}
        )
    )
      @http = JsonRequest.new(conn)
      @username = username
      @pass = pass
      yield(self) if block_given?
    end
  end
end
