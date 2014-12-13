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

      def initialize(options = {})
        fail ArgumentError, 'Uri must be set' unless options[:uri]
        @uri   = options[:uri]
        @token = options[:token]
      end

      def find_one(entity, id)
        response = raw_get("/v1/#{entity.base_path}/#{id}")
        fail Exception, "#{response.status}: #{response.body}" unless response.status == 200
        instance_from(entity, response.body)
      end

      def create(entity, hash)
        response = raw_post("/v1/#{entity.base_path}", hash)
        fail Exception, "#{response.status}: #{response.body}" unless response.status == 201
        instance_from(entity, response.body)
      end

      def raw_get(url)
        connection.get do |request|
          request.url url
          request.headers['Authorization'] = token unless token.nil?
        end
      end

      def raw_post(url, hash)
        connection.post do |request|
          request.url url
          request.headers['Authorization'] = token unless token.nil?
          request.body = hash.to_json
        end
      end

      def connection
        @connection ||= Faraday.new url: uri do |faraday|
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
