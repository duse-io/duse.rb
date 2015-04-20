require 'duse/cli/account_password_change.rb'
require 'duse/cli/account_password_reset.rb'

module Duse
  module CLI
    class AccountPassword < MetaCommand
      subcommand AccountPasswordChange
      subcommand AccountPasswordReset

      description 'Manage your password'
    end
  end
end

