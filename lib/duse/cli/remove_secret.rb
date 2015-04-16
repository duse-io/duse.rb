require 'duse/cli'

module Duse
  module CLI
    class RemoveSecret < ApiCommand
      description 'Delete a secret'

      def run(secret_id = nil)
        secret_id ||= terminal.ask('Secret to delete: ').to_i

        Duse::Secret.delete secret_id

        success 'Successfully deleted'
      rescue Duse::Client::Error => e
        error e.message
      end

      def self.command_name
        'delete'
      end
    end
  end
end
