require 'duse/cli'

module Duse
  module CLI
    class Config < Command
      description 'Configure the client'

      def run
        config.uri = terminal.ask('Uri to the duse instance you want to use: ') { |q| q.default = config.uri }
        CLIConfig.save(config)
      rescue ArgumentError
        error 'Not an uri'
      end
    end
  end
end
