require 'duse/cli'
require 'openssl'
require 'duse/cli/key_helper'
require 'duse/cli/share_with_user'
require 'duse/cli/secret_generator'

module Duse
  module CLI
    class SecretAdd < ApiCommand
      include KeyHelper
      include ShareWithUser

      description 'Interactively create a new secret, or set values via options'

      on('-t', '--title [TITLE]',   'The title for the secret to save')
      on('-s', '--secret [SECRET]', 'The secret to save')
      on('-g', '--generate-secret', 'Automatically generate the secret')
      on('-f', '--file [FILE]',     'Read the secret to save from this file')
      on('--folder [FOLDER]',       'The folder to put the secret in')

      def run
        self.title  ||= terminal.ask 'What do you want to call this secret? '
        self.secret = File.read(self.file) if file?
        self.secret = SecretGenerator.new.generated_password if generate_secret?
        self.secret ||= terminal.ask 'Secret to save: '
        users       = who_to_share_with
        if self.folder.nil? && terminal.agree('Put secret in a folder other than the root folder?[y/n] ')
          self.folder = terminal.ask 'Which folder do you want to put the secret in? (provide the id) '
        end

        user = Duse::User.current
        ensure_matching_keys_for user
        private_key = config.private_key_for user
        secret_hash = Duse::Client::CreateSecret.with(
          title: self.title,
          secret_text: self.secret,
          folder_id: self.folder,
          users: users
        ).sign_with(private_key).build

        response = Duse::Secret.create secret_hash
        success 'Secret successfully created!'
      end
    end
  end
end
