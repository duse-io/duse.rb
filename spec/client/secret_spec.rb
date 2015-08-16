# encoding: UTF-8

RSpec.describe Duse::Client::Secret do
  before :each do
    Duse.config = Duse::CLIConfig.new({ 'uri' => 'https://example.com/'})
  end

  describe '.all' do
    it 'loads a users secrets without shares' do
      stub_get_secrets
      secrets = Duse::Secret.all

      expect(secrets.length).to eq 1
      expect(secrets.class).to be Array
      secrets.each do |secret|
        expect(secret.class).to be Duse::Client::Secret
      end
      secret = secrets.first
      expect(secret.title).to eq 'test'
      expect(secret.attributes['shares']).to eq nil
    end
  end

  describe '.find' do
    context 'secret exists' do
      it 'loads a single secret with shares' do
        stub_secret_get

        secret = Duse::Secret.find 1

        expect(secret.title).to eq 'test'
        expect(secret.decrypt(user_private_key)).to eq 'test'
      end
    end

    context 'secret does not exist' do
      it 'raises an exception when requesting a non existant secret' do
        stub_request(:get, "https://example.com/secrets/2").
          with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
          to_return(status: 404, body: "", headers: {})
        expect { Duse::Secret.find 2 }.to raise_error Duse::Client::NotFound
      end
    end
  end

  describe '#delete' do
    it 'deletes an existing secret by id' do
      stub_secret_delete
      Duse::Secret.delete 1
    end
  end

  describe '.delete' do
    it 'can delete a previously retrieved secret' do
      stub_secret_get
      stub_secret_delete
      secret = Duse::Secret.find 1
      secret.delete
    end
  end

  describe '.create' do
    it 'builds a secret' do
      stub_create_secret
      current_user = OpenStruct.new id: 1, public_key: user_public_key
      server_user = OpenStruct.new id: 2, public_key: server_public_key

      secret_json = Duse::Client::CreateSecret.with(
        title: 'secret title',
        secret_text: 'test',
        users: [current_user, server_user]
      ).sign_with(user_private_key).build
      secret = Duse::Secret.create secret_json

      expect(secret.title).to eq 'test'
      expect(secret.decrypt(user_private_key)).to eq 'test'
    end
  end

  describe 'creation process' do
    context 'own and server user' do
      def test_working_encryption_and_decryption_for(plaintext)
        current_user = OpenStruct.new id: 1, public_key: user_public_key
        server_user = OpenStruct.new id: 2, public_key: server_public_key
        secret = Duse::Client::CreateSecret.with(
          title: 'test',
          secret_text: plaintext,
          users: [current_user, server_user]
        ).sign_with(user_private_key).build

        server_share = Duse::Encryption::Asymmetric.decrypt(server_private_key, secret[:shares][1]['content'])
        secret[:shares][1]['content'], secret[:shares][1]['signature'] = Duse::Encryption::Asymmetric.encrypt(user_private_key, user_public_key, server_share)

        shares = secret[:shares].map { |s| Duse::Client::Share.new(s) }
        secret = Duse::Client::Secret.new shares: shares, cipher_text: secret[:cipher_text]
        decrypted_secret = secret.decrypt(user_private_key)

        expect(decrypted_secret).to eq plaintext
      end

      it 'can decrypt the encrypted' do
        secret_text = 'test'
        test_working_encryption_and_decryption_for(secret_text)
      end

      it 'can hanle 4096 bit rsa keys' do
        secret_text = OpenSSL::PKey::RSA.generate(4096).to_s
        test_working_encryption_and_decryption_for(secret_text)
      end

      it 'can handle any utf-8 character' do
        secret_text = 'äõüß'
        test_working_encryption_and_decryption_for(secret_text)
      end
    end
  end

  describe 'update process' do
    context 'changin users' do
      it 'leaves the cipher text unchanged and generates new shares' do
        stub_secret_get
        current_user = OpenStruct.new id: 1, public_key: user_public_key
        server_user = OpenStruct.new id: 2, public_key: server_public_key
        secret = Duse::Secret.find(1)
        secret_hash = Duse::Client::UpdateSecret.values(
          secret,
          { users: [current_user, server_user] }
        ).encrypt_with(user_private_key).build

        shares = secret_hash[:shares].map { |s| Duse::Client::Share.new(s) }
        server_share = Duse::Encryption::Asymmetric.decrypt(server_private_key, shares[1].content)
        shares[1].content, shares[1].signature = Duse::Encryption::Asymmetric.encrypt(user_private_key, user_public_key, server_share)

        new_secret = Duse::Client::Secret.new shares: shares, cipher_text: secret.cipher_text
        decrypted_secret = new_secret.decrypt(user_private_key)

        expect(decrypted_secret).to eq 'test'
        expect(new_secret.shares).not_to eq secret.shares
      end
    end
  end
end

