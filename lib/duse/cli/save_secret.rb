require 'duse/cli'
require 'openssl'
require 'duse/cli/key_helper'
require 'duse/cli/share_with_user'
require 'duse/cli/secret_generator'

module Duse
  module CLI
    class SaveSecret < ApiCommand
      include KeyHelper
      include ShareWithUser

      description 'Save a new secret'

      on('-t', '--title [TITLE]',   'The title for the secret to save')
      on('-s', '--secret [SECRET]', 'The secret to save')
      on('-g', '--generate-secret', 'Automatically generate the secret')
      on('-f', '--file [FILE]',     'Read the secret to save from this file')

      def run
        self.title  ||= terminal.ask 'What do you want to call this secret? '
        self.secret = File.read(self.file) if file?
        self.secret = SecretGenerator.new.generated_password if generate_secret?
        self.secret ||= terminal.ask 'Secret to save: '
        users       = who_to_share_with

        current_user = Duse::User.find('me')
        ensure_matching_keys_for current_user
        private_key = config.private_key_for current_user
        secret      = Duse::Client::Secret.new title: self.title, secret_text: self.secret, users: users
        secret_hash = Duse::Client::SecretMarshaller.new(secret, private_key).to_h

        response = Duse::Secret.create secret_hash
        success 'Secret successfully created!'
      end

      private

      def self.command_name
        'save'
      end
    end
  end
end
