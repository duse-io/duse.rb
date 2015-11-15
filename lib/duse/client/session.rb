require 'duse/client/entity'
require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module Duse
  module Client
    class Error < StandardError; end
    class SSLError < Error; end
    class NotLoggedIn < Error; end
    class NotAuthorized < Error; end
    class NotFound < Error; end
    class ValidationFailed < Error; end

    class Session
      attr_accessor :config

      def find_one(entity, id)
        response_body = get("/#{entity.base_path}/#{id}")
        instance_from(entity, response_body)
      end

      def find_many(entity, params = {})
        response_body = get("/#{entity.base_path}")
        instances_from(entity, response_body)
      end

      def create(entity, hash)
        response_body = post("/#{entity.base_path}", hash)
        instance_from(entity, response_body)
      end

      def update(entity, id, hash)
        response_body = patch("/#{entity.base_path}/#{id}", hash)
        instance_from(entity, response_body)
      end

      def delete_one(entity, id)
        delete("/#{entity.base_path}/#{id}")
      end

      def get(*args)
        raw(:get, *args)
      end

      def post(*args)
        raw(:post, *args)
      end

      def patch(*args)
        raw(:patch, *args)
      end

      def delete(*args)
        raw(:delete, *args)
      end

      def raw(*args)
        process_raw_http_response raw_http_request(*args)
      end

      def process_raw_http_response(response)
        case response.status
        when 0             then raise SSLError, 'SSL error: could not verify peer'
        when 200..299      then JSON.parse(response.body) rescue response.body
        when 301, 303      then raw(:get, response.headers['Location'])
        when 302, 307, 308 then raw(verb, response.headers['Location'])
        when 401           then raise NotLoggedIn,      error_msg(response.body)
        when 403           then raise NotAuthorized,    error_msg(response.body)
        when 404           then raise NotFound,         error_msg(response.body)
        when 422           then raise ValidationFailed, error_msg(response.body)
        when 400..499      then raise Error,            error_msg(response.body)
        when 500..599      then raise Error,            error_msg(response.body)
        else raise Error, "unhandled status code #{response.status}"
        end
      end

      def raw_http_request(*args)
        connection.public_send(*args) do |request|
          request.headers['Authorization'] = config.token unless config.token.nil?
          request.headers['Accept'] = 'application/vnd.duse.1+json'
        end
      end

      def error_msg(json)
        result = JSON.parse(json)['message']
        result = result.join "\n" if result.is_a? Array
        result
      rescue
        json
      end

      def connection
        fail ArgumentError, 'Uri must be set' if config.uri.nil?

        @connection ||= Faraday.new faraday_options do |faraday|
          faraday.request  :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter  faraday_adapter
        end
      end

      def faraday_adapter
        :typhoeus
      end

      private

      def faraday_options
        opts = {
          url: config.uri
        }
        opts.merge!({ ssl: { verify: false } }) if ENV['IGNORE_SSL'] == 'true'
        opts
      end

      def instances_from(entity, array)
        array.map { |e| instance_from(entity, e) }
      end

      def instance_from(entity, hash)
        instance = entity.new
        instance.curry = curry_by_entity(entity)
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

      def curry_by_entity(entity)
        Duse.const_get(entity.name.split("::").last)
      end
    end
  end
end
