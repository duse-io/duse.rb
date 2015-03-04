require 'yaml'

module Duse
  class PrivateKeyMissing < StandardError; end

  module CLIConfig
    extend self

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

    def uri=(uri)
      fail ArgumentError, 'Not an uri' unless uri =~ URI.regexp
      set 'uri', uri
    end

    def uri
      get 'uri'
    end

    def token=(token)
      fail ArgumentError, 'Token must be a string'  unless token.is_a? String
      fail ArgumentError, 'Token must not be empty' if token.empty?
      set 'token', token
    end

    def token
      get 'token'
    end

    def set(key, value)
      config = load
      config[key] = value
      save(config)
    end

    def get(key)
      load[key]
    end

    def config
      load
    end

    def config_file
      File.join config_dir, 'config.yml'
    end

    def config_dir
      File.join Dir.home, '.config', 'duse'
    end

    def private_key_file_for(user)
      File.join config_dir, user.username
    end
    
    private

    def load
      config = YAML.load load_config_file
      return {} unless config.is_a? Hash
      config
    end

    def save(config)
      FileUtils.mkdir_p config_dir
      File.open(config_file, 'w') do |file|
        file.write config.to_yaml
        file.chmod 0600
      end
    end

    def load_config_file
      # pretend like it's an empty file if config does not exists
      return "--- {}\n" unless File.exist? config_file
      File.read config_file
    end
  end
end
