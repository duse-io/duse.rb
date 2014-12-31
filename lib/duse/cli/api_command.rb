module Duse
  module CLI
    class ApiCommand < Command
      abstract

      def execute
        ensure_uri_is_set
        authenticate
        run *arguments
      rescue Duse::Client::NotFound => e
        error e.message
      rescue Duse::Client::ValidationFailed => e
        begin
          message = JSON.parse e.message
          message = message['message'].join("\n") if message.is_a? Hash
          error message
        rescue JSON::ParserError => e
          error 'Parsing error'
        end
      end

      private

      def ensure_uri_is_set
        error 'not configured, please run "duse config"' if config.uri.nil?
      end

      def authenticate
        error 'not logged in, please run "duse login"' if config.token.nil?
        Duse.session = Duse::Client::Session.new(
          uri:   config.uri,
          token: config.token
        )
      end
    end
  end
end
