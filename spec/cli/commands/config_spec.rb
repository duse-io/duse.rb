require 'duse/cli/config'
require 'fakefs/safe'

describe Duse::CLI::Config do
  it 'should handle a false uri correctly' do
    expect(run_cli('config') { |i| i.puts('test') }.err).to eq(
      "Not an uri\n"
    )
  end

  it 'should process a correct uri' do
    FakeFS do
      FileUtils.mkdir_p(File.dirname(Duse::CLIConfig.config_file))
      run = run_cli('config') { |i| i.puts('https://duse.io/') }
      expect(run.err).to eq('')
      expect(run.success?).to be true
    end
  end
end
