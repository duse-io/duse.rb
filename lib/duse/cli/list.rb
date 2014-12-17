require 'duse/cli'

module Duse
  module CLI
    class List < ApiCommand
      def run
        Duse.session = Duse::Client::Session.new(uri: CLIConfig.uri, token: CLIConfig.token)
        secrets = Duse::Secret.all
        number  = secrets.length + 1
        secrets.each_with_index do |s, i|
          puts "#{(i+1).to_s.rjust(number.to_s.length)}: #{s.title}"
        end
      end
    end
  end
end
