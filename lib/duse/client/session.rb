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
        response = connection.get do |request|
          request.url "/v1/#{entity.base_path}/#{id}"
          request.headers['Authorization'] = token
        end
        fail Exception, "#{response.status}: #{response.body}" unless response.status == 200
        instance_from(entity, response.body)
      end

      def create(entity, hash)
        response = connection.post do |request|
          request.url "/v1/#{entity.base_path}"
          request.headers['Authorization'] = token
          request.body = hash.to_json
        end
        fail Exception, "#{response.status}: #{response.body}" unless response.status == 201
        instance_from(entity, response.hash)
      end

      def connection
        @connectoin ||= Faraday.new url: uri do |faraday|
          faraday.request  :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter  Faraday.default_adapter
        end
      end

      private

      def instance_from(entity, hash)
        instance = entity.new
        entity.attributes.each do |attribute|
          instance.public_send("#{attribute}=", hash[attribute])
        end
        instance
      end
    end
  end
end
