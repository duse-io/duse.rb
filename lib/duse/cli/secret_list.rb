require 'duse/cli'

module Duse
  module CLI
    class SecretList < ApiCommand
      description 'List all secrets you have access to'

      def run
        secrets = Duse::Secret.all
        secrets.each do |s|
          puts "#{s.id}: #{s.title}"
        end
        if secrets.empty?
          say 'You have not yet saved any secrets, ' \
            'you can do so with "duse secret save".'
        end
      end
    end
  end
end