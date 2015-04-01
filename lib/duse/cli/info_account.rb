require 'duse/cli'

module Duse
  module CLI
    class InfoAccount < ApiCommand
      description 'view your account information'

      def run
        user = Duse::User.find('me')
        say "
          Username: #{user.username}
          Email:    #{user.email}
        ".gsub(/^( |\t)+/, "")
      end
    end
  end
end

