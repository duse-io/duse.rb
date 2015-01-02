module Duse
  module CLI
    class DeleteSecret < ApiCommand
      description 'Delete a secret'

      def run(*arguments)
        secret_id = arguments.shift unless arguments.empty?
        secret_id ||= terminal.ask('Secret to delete: ').to_i

        Duse::Secret.delete secret_id

        success 'Successfully deleted'
      rescue Duse::Client::Error => e
        error e.message
      end

      def command_name
        'secret delete'
      end
    end
  end
end
