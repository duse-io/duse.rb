require 'duse/cli'

module Duse
  module CLI
    class Config < Command
      description 'Configure the client'

      def run
        config.uri = terminal.ask('Uri to the duse instance you want to use: ')
      rescue ArgumentError
        error 'Not an uri'
      end
    end
  end
end
