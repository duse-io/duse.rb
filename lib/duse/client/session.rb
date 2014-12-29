require 'secret_sharing'
require 'json'
require 'openssl'
require 'duse/encryption'
require 'faraday'
require 'faraday_middleware'

module Duse
  module Client
    class Error < StandardError; end
    class SSLError < Error; end
    class NotLoggedIn < Error; end
    class NotAuthorized < Error; end
    class NotFound < Error; end
    class ValidationFailed < Error; end

    class Session
      attr_reader :token, :uri

      def initialize(options = {})
        fail ArgumentError, 'Uri must be set' unless options[:uri]
        @uri   = options[:uri]
        @token = options[:token]
      end

      def find_one(entity, id)
        response_body = get("/v1/#{entity.base_path}/#{id}")
        instance_from(entity, response_body)
      end

      def find_many(entity, params = {})
        response_body = get("/v1/#{entity.base_path}")
        instances_from(entity, response_body)
      end

      def create(entity, hash)
        response_body = post("/v1/#{entity.base_path}", hash)
        instance_from(entity, response_body)
      end

      def delete_one(entity, id)
        delete("/v1/#{entity.base_path}/#{id}")
      end

      def get(*args)
        raw(:get, *args)
      end

      def post(*args)
        raw(:post, *args)
      end

      def delete(*args)
        raw(:delete, *args)
      end

      def raw(verb, url, *args)
        result = connection.public_send(verb, url, *args) do |request|
          request.headers['Authorization'] = token unless token.nil?
        end

        case result.status
        when 0             then raise SSLError, 'SSL error: could not verify peer'
        when 200..299      then JSON.parse(result.body) rescue result.body
        when 301, 303      then raw(:get, result.headers['Location'])
        when 302, 307, 308 then raw(verb, result.headers['Location'])
        when 401           then raise NotLoggedIn,      'not logged in'
        when 403           then raise NotAuthorized,    'not authorized to access this resource'
        when 404           then raise NotFound,         'not found'
        when 422           then raise ValidationFailed, result.body
        when 400..499      then raise Error,            "%s: %p" % [result.status, result.body]
        when 500..599      then raise Error,            "server error (%s: %p)" % [result.status, result.body]
        else raise Error, "unhandled status code #{result.status}"
        end
      end

      def connection
        @connection ||= Faraday.new url: uri do |faraday|
          faraday.request  :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter  *faraday_adapter
        end
      end

      def faraday_adapter
        Faraday.default_adapter
      end

      private

      def instances_from(entity, array)
        array.map { |e| instance_from(entity, e) }
      end

      def instance_from(entity, hash)
        instance = entity.new
        entity.attributes.each do |attribute|
          if hash.has_key? attribute
            value = hash[attribute]
            if Entity::MAP.has_key? attribute
              nested_entity = Entity::MAP[attribute]
              value = hash[attribute].map { |e| instance_from(nested_entity, e) }
            end
            instance.public_send("#{attribute}=", value)
          end
        end
        instance
      end
    end
  end
end
