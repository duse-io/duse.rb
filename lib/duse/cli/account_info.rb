require 'duse/cli'

module Duse
  module CLI
    class AccountInfo < ApiCommand
      description 'view your account information'

      def run
        user = Duse::User.current
        say "
          Username: #{user.username}
          Email:    #{user.email}
        ".gsub(/^( |\t)+/, "")
      end
    end
  end
end

