describe Duse::Client::User do
  before :each do
    Duse.uri = 'https://example.com/'
  end

  def stub_create_user
    payload = {
      'id' => 2,
      'username' => 'flower-pot',
      'email' => 'flower-pot@example.org',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/2'
    }.to_json

    stub_request(:post, "https://example.com/users").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 201, body: payload, headers: {})
  end

  it 'creates correct entity instances from user array' do
    stub_get_users
    users = Duse::User.all

    expect(users.length).to eq 3
    expect(users.class).to be Array
    users.each do |user|
      expect(user.class).to be Duse::Client::User
    end
  end

  it 'creates correct user entity from json create response' do
    stub_create_user
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n"

    user = Duse::User.create(
      'username' => 'flower-pot',
      'email'    => 'flower-pot@example.org',
      'password' => 'Passw0rd!',
      'password_confirmation' => 'Passw0rd!',
      'public_key' => public_key
    )

    expect(user.username).to eq 'flower-pot'
    expect(user.email).to eq 'flower-pot@example.org'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should create the correct entity when requesting own user' do
    stub_user_me_get
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n"

    user = Duse::User.find 'me'

    expect(user.username).to eq 'flower-pot'
    expect(user.email).to eq 'flower-pot@example.org'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should create the correct entity when requesting server user' do
    stub_server_user_get
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n"

    user = Duse::User.find 'server'

    expect(user.username).to eq 'server'
    expect(user.email).to eq 'server@localhost'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should create the correct entity when requesting a specific user' do
    stub_get_other_user
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n"

    user = Duse::User.find 3

    expect(user.username).to eq 'adracus'
    expect(user.email).to eq 'adracus@example.org'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should reload the entity when necessary' do
    stub_get_users
    stub_get_other_user
    users = Duse::User.all
    user  = users.last

    expect(users.length).to eq 3
    expect(user.attributes['public_key']).to be nil
    expect(user.username).to eq 'adracus'
    expect(user.email).to eq 'adracus@example.org'
    expect(user.public_key.to_s).to eq "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n"
  end
end
