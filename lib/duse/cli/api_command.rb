module Duse
  module CLI
    class ApiCommand < Command
      abstract

      def execute
        ensure_uri_is_set
        authenticate
        run *arguments
      rescue Duse::Client::NotFound
        error 'Could not be found'
      end

      private

      def ensure_uri_is_set
        error 'not configured, please run "duse config"' if config.uri.nil?
      end

      def authenticate
        error 'not logged in, please run "duse login"' if config.token.nil?
        Duse.session = Duse::Client::Session.new(
          uri:   CLIConfig.uri,
          token: CLIConfig.token
        )
      end
    end
  end
end
