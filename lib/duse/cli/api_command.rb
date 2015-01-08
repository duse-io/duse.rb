require 'json'

module Duse
  module CLI
    class ApiCommand < Command
      abstract

      def execute
        ensure_uri_is_set
        authenticate
        run *arguments
      rescue Duse::Client::ValidationFailed => e
        begin
          message = JSON.parse e.message
          message = message['message'].join("\n") if message.is_a? Hash
          error message
        rescue JSON::ParserError => e
          error 'Parsing error'
        end
      rescue Duse::Client::NotLoggedIn
        error "not logged in, run `#$0 login`"
      rescue Duse::Client::Error => e
        error e.message
      rescue Interrupt
        say "\naborted!"
      end

      private

      def ensure_uri_is_set
        error "client not configured, run `#$0 config`" if config.uri.nil?
        Duse.uri = config.uri
      end

      def authenticate
        fail Duse::Client::NotLoggedIn if config.token.nil?
        Duse.token = config.token
      end
    end
  end
end
