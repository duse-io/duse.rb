require 'duse/cli'

module Duse
  module CLI
    class SecretRemove < ApiCommand
      description 'Delete a secret'

      def run(secret_id = nil)
        secret_id ||= terminal.ask('Secret to delete: ').to_i

        Duse::Secret.delete secret_id

        success 'Successfully deleted'
      rescue Duse::Client::Error => e
        error e.message
      end
    end
  end
end
