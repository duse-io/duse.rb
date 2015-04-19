require 'duse/cli/cli_config'
require 'fileutils'
require 'fakefs/spec_helpers'

describe Duse::CLIConfig do
  include FakeFS::SpecHelpers

  before :each do
    @dir = File.dirname(Duse::CLIConfig.config_file)
    FileUtils.mkdir_p @dir
  end

  after :each do
    FileUtils.rm_rf @dir
  end

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
    File.open(Duse::CLIConfig.config_file, 'w') do |f|
      f.write config.to_yaml
      f.chmod 0600
    end

    expect(Duse::CLIConfig.load).to eq config
  end

  it 'should use an empty config when config is malformatted' do
    File.open(Duse::CLIConfig.config_file, 'w') do |f|
      f.write 'test'
      f.chmod 0600
    end

    expect(Duse::CLIConfig.load).to eq Hash.new
  end
end
