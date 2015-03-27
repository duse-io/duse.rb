require 'duse/cli/config'
require 'fakefs/safe'

describe Duse::CLI::Config do
  include FakeFS::SpecHelpers

  before :each do
    @dir = File.dirname(Duse::CLIConfig.config_file)
    FileUtils.mkdir_p @dir
  end

  after :each do
    FileUtils.rm_rf @dir
  end

  it 'should handle a false uri correctly' do
    expect(run_cli('config') { |i| i.puts('test') }.err).to eq(
      "Not an uri\n"
    )
  end

  it 'should process a correct uri' do
    run = run_cli('config') { |i| i.puts('https://duse.io/') }
    expect(run.err).to eq('')
    expect(run.success?).to be true
  end
end
