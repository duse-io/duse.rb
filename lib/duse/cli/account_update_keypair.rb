require 'duse/cli'
require 'duse/cli/key_helper'
require 'duse/cli/password_helper'

module Duse
  module CLI
    class AccountUpdateKeypair < ApiCommand
      include KeyHelper
      include PasswordHelper

      description 'Change your keypair (The old private key is not removed in case it is needed for recovery)'

      def run
        user = Duse::User.current
        old_private_key = Duse::CLIConfig.new.private_key_for(user)
        new_private_key = choose_key
        password = ask_for_current_password
        Duse::User.update(user.id, {
          public_key: new_private_key.public_key.to_s,
          current_password: password,
        })

        user.reload
        shares = Duse::Share.all
        shares = shares.map do |share|
          plaintext = share.decrypt(old_private_key)
          content, signature = Encryption::Asymmetric.encrypt(new_private_key, user.public_key, plaintext)

          {
            id: share.id,
            content: content,
            signature: signature,
          }
        end

        Duse::Share.update_all(shares)
        Duse::CLIConfig.new.save_private_key_for user, new_private_key.to_pem

        success 'Successfully updated your keypair account!'
      end
    end
  end
end
