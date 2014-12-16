require 'duse/cli'

module Duse
  module CLI
    class List < ApiCommand
      def run
        Duse.session = Duse::Client::Session.new(uri: CLIConfig.uri, token: CLIConfig.token)
        secrets = Duse::Secret.all
        secrets.each_with_index do |s, i|
          puts "#{i+1}: #{s.title}"
        end
      end
    end
  end
end
