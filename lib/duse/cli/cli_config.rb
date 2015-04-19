require 'yaml'
require 'duse/client/config'

module Duse
  class PrivateKeyMissing < StandardError; end

  class CLIConfig < Duse::Client::Config
    def private_key_for(user)
      private_key_filename = private_key_file_for user
      fail PrivateKeyMissing unless File.exists? private_key_filename
      OpenSSL::PKey::RSA.new File.read private_key_filename
    end

    def save_private_key_for(user, private_key)
      File.open(private_key_file_for(user), 'w') do |file|
        file.write private_key
      end
    end

    def self.load
      config = YAML.load load_config_file
      return {} unless config.is_a? Hash
      config
    end

    def self.save(config)
      FileUtils.mkdir_p config_dir
      File.open(config_file, 'w') do |file|
        file.write config.to_h.to_yaml
        file.chmod 0600
      end
    end

    def self.config_file
      File.join config_dir, 'config.yml'
    end

    def self.config_dir
      File.join Dir.home, '.config', 'duse'
    end

    def private_key_file_for(user)
      File.join self.class.config_dir, user.username
    end

    private

    def self.load_config_file
      # pretend like it's an empty file if config does not exists
      return "--- {}\n" unless File.exist? config_file
      File.read config_file
    end
  end
end
