require 'secret_sharing'
require 'duse/cli'
require 'json'
require 'openssl'
require 'duse/encryption'
require 'duse/cli/save_secret'
require 'duse/cli/get_secret'
require 'duse/cli/list_secrets'

module Duse
  module CLI
    class Secret < ApiCommand
      subcommand :save, SaveSecret
      subcommand :get,  GetSecret
      subcommand :list, ListSecrets

      def run(*arguments)
        say "Display help text for subcommands. TBD."
      end

      private

      def who_to_share_with
        user_ids = []
        wants_to_share = terminal.agree 'Do you want to share this secret?[Y/n] '
        if(wants_to_share)
          terminal.say 'Who do you want to share this secret with?'
          users = [{id: 1, username: 'adracus'}, {id: 2, username: 'flower-pot'}]
          users.each_with_index do |user, index|
            terminal.say "#{index+1}: #{user[:username]}"
          end
          user_selection = terminal.ask 'Separate with commas, to select multiple'
          comma_separated_int_list(user_selection).each do |index|
            user_ids << users[index-1][:id] if users[index-1]
          end
        end
        user_ids
      end

      def comma_separated_int_list(string)
        string.split(',').map(&:strip).delete_if(&:empty?).map(&:to_i)
      end
    end
  end
end
