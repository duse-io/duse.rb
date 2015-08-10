require 'duse/cli/cli_config'

RSpec.describe Duse::CLIConfig, :fs => :fake do
  describe '.load' do
    context 'config file does not exist' do
      it 'returns an empty hash' do
        config = Duse::CLIConfig.load
        expect(config).to eq Hash.new
      end
    end

    context 'valid config file' do
      it 'correctly loads the config file' do
        config = { 'uri' => 'https://duse.io/' }
        FileUtils.mkdir_p Duse::CLIConfig.config_dir
        File.open(Duse::CLIConfig.config_file, 'w') do |f|
          f.write config.to_yaml
          f.chmod 0600
        end

        expect(Duse::CLIConfig.load).to eq config
      end
    end

    context 'malformed config file' do
      it 'uses an empty config when config is malformatted' do
        FileUtils.mkdir_p Duse::CLIConfig.config_dir
        File.open(Duse::CLIConfig.config_file, 'w') do |f|
          f.write 'not yaml content'
          f.chmod 0600
        end

        expect(Duse::CLIConfig.load).to eq Hash.new
      end
    end
  end

  describe '.save' do
    it 'builds the config file correctly' do
      config = Duse::CLIConfig.new
      config.uri = 'https://duse.io/'
      Duse::CLIConfig.save(config)

      expect(File.exist? Duse::CLIConfig.config_file).to be true
      expected_file_content = "---\nuri: https://duse.io/\n"
      expect(File.read Duse::CLIConfig.config_file).to eq expected_file_content
    end
  end
end
