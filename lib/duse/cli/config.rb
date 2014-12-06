require 'duse/cli'

module Duse
  module CLI
    class Config < Command
      def execute
        uri = terminal.ask('Uri to your duse instance: ').to_s
        CLIConfig.uri = uri
      rescue ArgumentError
        error 'Not an uri'
      end
    end
  end
end
