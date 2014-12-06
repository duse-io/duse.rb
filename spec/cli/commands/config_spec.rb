require 'duse/cli/config'

describe Duse::CLI::Config do
  it 'should set the uri in the config correctly' do
    allow(Duse::CLIConfig).to receive(:uri=)
    Duse::CLI::Config.execute(['https://duse.io/'])
  end
end
