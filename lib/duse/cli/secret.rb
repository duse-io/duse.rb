require 'duse/cli/secret_add'
require 'duse/cli/secret_get'
require 'duse/cli/secret_list'
require 'duse/cli/secret_remove'
require 'duse/cli/secret_update'

module Duse
  module CLI
    class Secret < MetaCommand
      subcommand SecretAdd
      subcommand SecretGet
      subcommand SecretList
      subcommand SecretRemove
      subcommand SecretUpdate

      description 'Save, retrieve and delete secrets'
    end
  end
end
