require 'duse/cli/add_secret'
require 'duse/cli/get_secret'
require 'duse/cli/list_secrets'
require 'duse/cli/remove_secret'
require 'duse/cli/update_secret'

module Duse
  module CLI
    class Secret < ApiCommand
      subcommand :add, AddSecret
      subcommand :get, GetSecret
      subcommand :list, ListSecrets
      subcommand :rm, RemoveSecret
      subcommand :update, UpdateSecret

      description 'Save, retrieve and delete secrets'

      def run
        say help
      end
    end
  end
end
