require 'yaml'

module Duse
  module CLIConfig
    extend self

    def uri=(uri)
      fail ArgumentError, 'Not an uri' unless uri =~ URI.regexp
      config['uri'] = uri
      save
    end

    def uri
      config['uri']
    end

    def config
      @config ||= load
    end
    
    private

    def load
      YAML.load load_config_file
    end

    def save
      File.open(config_file, 'w') do |file|
        file.write(config.to_yaml)
        file.chmod(0600)
      end
    end

    def load_config_file
      # pretend like it's an empty file if config does not exists
      return '{}' unless File.exists? config_file
      File.read config_file 
    end

    def config_file
      File.join(Dir.home, '.duse.yml')
    end
  end
end
