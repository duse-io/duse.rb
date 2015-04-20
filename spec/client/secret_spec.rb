describe Duse::Client::Secret do
  before :each do
    Duse.config = Duse::CLIConfig.new({ 'uri' => 'https://example.com/'})
  end

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

  it 'loads a single secret with shares' do
    stub_secret_get
    private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"

    secret = Duse::Secret.find 1

    expect(secret.title).to eq 'test'
    expect(secret.decrypt(private_key)).to eq 'test'
  end

  it 'raises an exception when requesting a non existant secret' do
    stub_request(:get, "https://example.com/secrets/2").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 404, body: "", headers: {})
    expect { Duse::Secret.find 2 }.to raise_error Duse::Client::NotFound
  end

  it 'deletes an existing secret by id' do
    stub_secret_delete
    Duse::Secret.delete 1
  end

  it 'can delete a previously retrieved secret' do
    stub_secret_get
    stub_secret_delete
    secret = Duse::Secret.find 1
    secret.delete
  end

  it 'correctly builds a secret after creating it' do
    stub_create_secret
    private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"

    secret = Duse::Secret.create({
      title: 'test',
      parts: [[
        {
          user_id: 'server',
          content: "T6BKRp0U41zRRZ2NSRPwpJW7NjsSZaJ1eSSdtYNjchscXb5UIEqzSr/+B6Zy\nJ8JUA9CPrad+Z6s1CNNPGN6sJKtdAtzk+zJr5vTeg/4Aw42799A8cFPw/fE9\nd5K+IIYjn4Yxtypcv0I2j+dYsgDvN+mhosZ21cdibfX5PyyibuA=\n",
          signature: "XBMWwpKyO5K+S1dimX/7aZ4oX7dW5SDlf4KaagYUBoVm7ii7jX9jfLKWqrRL\nj2f85JYMSUQ3UoXVWT1LDWXXZIs3KO02xlvA+oflmx5ZSGx57TDvuYpusEBu\n/LNSpNj6ooROXTm+Xq+AvQfmt0bjQZCg/PSOt8Qx11q5JLmhL38=\n"
        },
        {
          user_id: 'me',
          content: "XMcasmkkD0eOB52ilT3sGUOy9ehHpsuIFnbmErKLsTq0PExcvSuGT6RwMKjE\nM3rS7Lu2nHgWm0IPSzi5Vd8ieJTgyayYgT9VCOOnKGqfAMmCpV0WrHpfNwLu\nUgH7VC3Wfk1F+6yzWAFOoYXBDUuIRRau4uswCpedp1pe3csmO+I=\n",
          signature: "dAhhcWeebiE5E9jfhexu+/zem1emWG2vBQed06f4CJJ24xrWDwUgX9kggHka\nsOWgu/RnCN/qzIuN8XCPgh2I1zQegd9d5FdAHUqXJRgpT2bvmAYPZ6DM6UYs\nB8OJ7+QgQy9EahTfhfbrSKuqtnX9103ftTZtiGagzFdYi5ylMNM=\n"
        }
      ]]
    })

    expect(secret.title).to eq 'test'
    expect(secret.decrypt(private_key)).to eq 'test'
  end

  it 'can handle any utf-8 character' do
    encoded_secret = Duse::Encryption.encode('äõüß')
    shares = SecretSharing.split_secret(encoded_secret, 2, 2)
    private_key = OpenSSL::PKey::RSA.new(1024)
    shares = shares.map { |p| Duse::Encryption.encrypt(private_key, private_key.public_key, p)[0] }
    secret = Duse::Client::Secret.new(parts: [shares])
    secret_text = secret.decrypt(private_key)
    expect(secret_text).to eq 'äõüß'
  end
end
