require 'duse/cli'

module Duse
  module CLI
    class ListSecrets < ApiCommand
      def run
        secrets = Duse::Secret.all
        number  = secrets.length + 1
        secrets.each_with_index do |s, i|
          puts "#{(i+1).to_s.rjust(number.to_s.length)}: #{s.title}"
        end
        if secrets.empty?
          say 'You have not yet saved any secrets, ' \
            'you can do so with "duse secret save".'
        end
      end
    end
  end
end