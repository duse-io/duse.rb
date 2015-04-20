require 'duse/cli/cli_config'

describe Duse::CLIConfig do
  it 'should return an empty hash when no config file exists' do
    config = Duse::CLIConfig.load
    expect(config).to eq Hash.new
  end

  it 'should build the config file correctly when setting the uri' do
    config = Duse::CLIConfig.new
    config.uri = 'https://duse.io/'
    Duse::CLIConfig.save(config)

    expect(File.exist? Duse::CLIConfig.config_file).to be true
    expected_file_content = "---\nuri: https://duse.io/\n"
    expect(File.read Duse::CLIConfig.config_file).to eq expected_file_content
  end

  it 'should correctly load the config file' do
    config = { 'uri' => 'https://duse.io/' }
    FileUtils.mkdir_p Duse::CLIConfig.config_dir
    File.open(Duse::CLIConfig.config_file, 'w') do |f|
      f.write config.to_yaml
      f.chmod 0600
    end

    expect(Duse::CLIConfig.load).to eq config
  end

  it 'should use an empty config when config is malformatted' do
    FileUtils.mkdir_p Duse::CLIConfig.config_dir
    File.open(Duse::CLIConfig.config_file, 'w') do |f|
      f.write 'not yaml content'
      f.chmod 0600
    end

    expect(Duse::CLIConfig.load).to eq Hash.new
  end
end
