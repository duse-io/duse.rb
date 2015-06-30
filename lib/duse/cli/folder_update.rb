require 'duse/cli'

module Duse
  module CLI
    class FolderUpdate < ApiCommand
      description 'update a folder'

      def run(folder_id)
        user = Duse::Folder.find(folder_id)
        terminal.say 'Leave blank if you do not wish to change'
        Duse::User.update(folder_id, {
          name: terminal.ask('New folder name: ') { |q| q.default = folder.name }
        })
        success 'Successfully updated!'
      end
    end
  end
end
