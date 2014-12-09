require 'secret_sharing'
require 'json'
require 'openssl'
require 'duse/encryption'
require 'faraday'
require 'faraday_middleware'

module Duse
  module Client
    class Session
      attr_reader :token, :uri

      def initialize(uri, token)
        @uri   = uri
        @token = token
      end

      def find_one(entity, id)
        connection.get do |request|
          request.url "/v1/#{entity.base_path}/#{id}"
          request.headers['Authorization'] = token
        end
      end

      def create(entity, hash)
        connection.post do |request|
          request.url "/v1/#{entity.base_path}"
          request.headers['Authorization'] = token
          request.body = hash.to_json
        end
      end

      def connection
        @connectoin ||= Faraday.new url: uri do |faraday|
          faraday.request  :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
