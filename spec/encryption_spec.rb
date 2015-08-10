require 'duse/encryption'

RSpec.describe Duse::Encryption do
  describe '.hmac' do
    it 'returns a base64 encoded hmac' do
      hash = Duse::Encryption.hmac('key', 'msg')
      expect(hash).to eq "LZPLwb4We8sWN6SiPL/wGnh48MUO6DOVTqUiG7G4xig=\n"
    end
  end
end
