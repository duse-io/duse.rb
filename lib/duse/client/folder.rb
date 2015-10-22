# encoding: UTF-8

require "duse/client/entity"

module Duse
  module Client
    class Folder < Entity
      FOLDER_SYMBOL = "📂"

      attributes :id, :name
      has :secrets
      has :subfolders

      id_field :id
      one  :folder
      one  :subfolder
      many :folders
      many :subfolders

      def children
        self.subfolders + self.secrets
      end

      # for now we will only try to show the folder icon on mac this might be
      # something we will remove if the support is not good enough
      def cli_icon_prefix
        ((/darwin/ =~ RUBY_PLATFORM) != nil) ? "#{FOLDER_SYMBOL}  " : ""
      end

      def id_name
        return "#{cli_icon_prefix}#{self.name}" if self.id.nil?
        "#{cli_icon_prefix}#{self.id}: #{self.name}"
      end

      def to_s
        "#{cli_icon_prefix}#{self.name}"
      end
    end
  end
end
