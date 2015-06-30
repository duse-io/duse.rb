require 'duse/cli'

module Duse
  module CLI
    class FolderRemove < ApiCommand
      description 'Delete a folder (does not delete the children)'

      def run(folder_id = nil)
        secret_id ||= terminal.ask('Folder to delete: ').to_i

        Duse::Folder.delete secret_id

        success 'Successfully deleted'
      rescue Duse::Client::Error => e
        error e.message
      end
    end
  end
end
