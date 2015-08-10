describe 'duse config', :fs => :fake do
  context 'false uri provided' do
    it 'errors with a message' do
      expect(run_cli('config') { |i| i.puts('test') }.err).to eq(
        "Not an uri\n"
      )
    end
  end

  context 'correct uri provided' do
    it 'accepts it' do
      run = run_cli('config') { |i| i.puts('https://duse.io/') }
      expect(run.err).to eq('')
      expect(run.success?).to be true
    end
  end
end
