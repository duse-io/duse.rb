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
        private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"

        secret = Duse::Secret.find 1

        expect(secret.title).to eq 'test'
        expect(secret.decrypt(private_key)).to eq 'test'
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
  end

  describe '#encrypt' do
    context 'own and server user' do
      def test_working_encryption_and_decryption_for(plaintext)
        current_user_private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"
        current_user_public_key =  OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n"
        server_user_private_key =  OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"
        server_user_public_key =   OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n"
        current_user = OpenStruct.new id: 1, public_key: current_user_public_key
        server_user = OpenStruct.new id: 2, public_key: server_user_public_key
        secret = Duse::Client::Secret.new title: 'test', secret_text: plaintext, users: [current_user, server_user]
        secret.encrypt(current_user_private_key)

        shares = secret.shares.map { |s| s['content'] }
        server_share = Duse::Encryption::Asymmetric.decrypt(server_user_private_key, shares[1])
        shares[1], _ = Duse::Encryption::Asymmetric.encrypt(current_user_private_key, current_user_public_key, server_share)

        secret = Duse::Client::Secret.new shares: shares, cipher_text: secret.cipher_text
        secret.decrypt(current_user_private_key)

        expect(secret.secret_text).to eq plaintext
      end

      it 'can decrypt the encrypted' do
        secret_text = 'test'
        test_working_encryption_and_decryption_for(secret_text)
      end

      it 'can hable 4096 bit rsa keys' do
        secret_text = "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"
        test_working_encryption_and_decryption_for(secret_text)
      end

      it 'can handle any utf-8 character' do
        secret_text = 'äõüß'
        test_working_encryption_and_decryption_for(secret_text)
      end
    end
  end
end

