require 'duse/cli/config'

describe Duse::CLI::Config do
  it 'handles a false uri correctly' do
    expect(run_cli('config') { |i| i.puts('test') }.err).to eq(
      "Not an uri\n"
    )
  end

  it 'accepts a correct uri' do
    run = run_cli('config') { |i| i.puts('https://duse.io/') }
    expect(run.err).to eq('')
    expect(run.success?).to be true
  end
end
