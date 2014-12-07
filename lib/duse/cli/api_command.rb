module Duse
  module CLI
    class ApiCommand < Command
      abstract

      def execute
        ensure_uri_is_set
        authenticate
        run *arguments
      end

      private

      def ensure_uri_is_set
        error 'not configured, please run "duse config"' if config.uri.nil?
      end

      def authenticate
        error 'not logged in, please run "duse login"' if config.token.nil?
      end

      def client
        Faraday.new url: Duse::CLIConfig.uri do |faraday|
          faraday.request  :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
