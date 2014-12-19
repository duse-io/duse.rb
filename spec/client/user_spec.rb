describe Duse::Client::User do
  it '' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n"

    user = Duse::User.create(
      'username' => 'flower-pot',
      'password' => 'Passw0rd!',
      'password_confirmation' => 'Passw0rd!',
      'public_key' => public_key
    )

    expect(user.username).to eq 'flower-pot'
    expect(user.public_key.to_s).to eq public_key
  end
end
