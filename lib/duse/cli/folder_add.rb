require 'duse/cli'

module Duse
  module CLI
    class FolderAdd < ApiCommand
      description 'Add a new folder'

      on('-n', '--name [name]', 'The folders name')
      on('-p', '--parent [parent]', 'The parent folder')

      def run
        self.name   ||= terminal.ask 'What to you want to call the new folder? '
        self.parent ||= terminal.ask 'What folder do you want this folder to be under? (provide the id) [root] ' 

        Duse::Folder.create(
          name: name,
          parent_id: parent
        )

        success 'Folder successfully created!'
      end
    end
  end
end
