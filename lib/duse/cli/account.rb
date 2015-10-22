require 'duse/cli/account_confirm'
require 'duse/cli/account_resend_confirmation'
require 'duse/cli/account_info'
require 'duse/cli/account_update'
require 'duse/cli/account_password'
require 'duse/cli/account_update_keypair'

module Duse
  module CLI
    class Account < MetaCommand
      subcommand AccountConfirm
      subcommand AccountResendConfirmation
      subcommand AccountInfo
      subcommand AccountUpdate
      subcommand AccountPassword
      subcommand AccountUpdateKeypair

      description 'Manage your account'
    end
  end
end

