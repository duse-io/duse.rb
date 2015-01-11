require 'duse/cli/save_secret'
require 'duse/cli/get_secret'
require 'duse/cli/list_secrets'
require 'duse/cli/delete_secret'
require 'duse/cli/update_secret'

module Duse
  module CLI
    class Secret < ApiCommand
      subcommand :save, SaveSecret
      subcommand :get,  GetSecret
      subcommand :list, ListSecrets
      subcommand :delete, DeleteSecret
      subcommand :update, UpdateSecret

      description 'Save, retrieve and delete secrets'

      def run(*arguments)
        say help
      end
    end
  end
end
