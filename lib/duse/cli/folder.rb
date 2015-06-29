require 'duse/cli/folder_list'
require 'duse/cli/folder_add'

module Duse
  module CLI
    class Folder < MetaCommand
      subcommand FolderList
      subcommand FolderAdd

      description 'Manage your folders'
    end
  end
end

