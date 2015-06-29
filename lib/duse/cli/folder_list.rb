require 'duse/cli'
require 'duse/cli/folder_add'
require 'tree_outline'

module Duse
  module CLI
    class FolderList < ApiCommand
      description 'Print all your folders'

      def run
        root_folders = Duse::Folder.all
        say TreeOutline.new(root_folders.first).children_method(:subfolders).label_method(:id_name).to_s
        say "\nAdd a new folder with `#{FolderAdd.full_command}`"
      end
    end
  end
end
