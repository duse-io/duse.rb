require 'duse/cli/save_secret'
require 'duse/cli/get_secret'
require 'duse/cli/list_secrets'
require 'duse/cli/delete_secret'

module Duse
  module CLI
    class Secret < ApiCommand
      subcommand :save, SaveSecret
      subcommand :get,  GetSecret
      subcommand :list, ListSecrets
      subcommand :delete, DeleteSecret

      def run(*arguments)
        say "Display help text for subcommands. TBD."
      end
    end
  end
end
