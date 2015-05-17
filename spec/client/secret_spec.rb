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
      current_user_private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"
      current_user_public_key =  OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n"
      server_user_public_key =   OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n"
      current_user = OpenStruct.new id: 1, public_key: current_user_public_key
      server_user = OpenStruct.new id: 2, public_key: server_user_public_key

      secret_json = Duse::Client::CreateSecret.with(
        title: 'secret title',
        secret_text: 'test',
        users: [current_user, server_user]
      ).sign_with(current_user_private_key).build
      secret = Duse::Secret.create secret_json

      expect(secret.title).to eq 'test'
      expect(secret.decrypt(current_user_private_key)).to eq 'test'
    end
  end

  describe 'creation process' do
    context 'own and server user' do
      def test_working_encryption_and_decryption_for(plaintext)
        current_user_private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"
        current_user_public_key =  OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n"
        server_user_private_key =  OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAvyvyAf7lnVx9eQcAS7JLYRHrqJJe51rAdanaUiiy8eek2Iyh\n6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/pcxutggTWCnUQUvXmEEm5qZ1KOIIl\nEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc8w+02wpcmWuzWKjoY/G5KV33UDz/\nLxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/7DyXIuiBosVpj9E9T4kpxs3/7RmU\nfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mbSVO6yf2YOcrPDRa3pgz7PIr225QJ\n+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SOpQIDAQABAoIBAQCHXFJrX1St64Nc\nYryu3HvLK6k1Hw7bucJ0jePsMK0j4+Uw/8LUrfp380ZOsYeTZ2IzZiaXl6v9x9St\nFbKXYb3mpz5fxZTYqrL4Suyvs8QmeRzIjj44obYmD4yKz2BoHPfBVkUgyZ5Uayl3\nRQX0aqbr478nKVsPttayfEawHcQBqTHPE9dfavuT14/64iqkrIya4ejFVXd1vYG2\nx+oKedPAnD3jr9foEHTqj1D4AeORwonbxFllh3K91IcabV3zdIZH0ICvYaaryceU\n2npp1H0mqETMZ97o3uMo8S5AEK7TsyB26WlD1IUSfwaP3apkog2WMNvgU4c2OD/q\nX8l3mA2BAoGBAOHGaZtBXQUSUD95eQAG/03F1Non21dD+aUtMbDn1Li6aOD+C+a4\ncJVZ+D2nMMIoQz3nEBIVoEdK4prugQXZJ87pvWwpZ/afRmTNSYWHnJmmg5/rvrZ5\nuvR17DwmS5ucTVOWcdryoG0O5KZqyAnpshLecr5PALY+cfG+fjo6KxNpAoGBANjD\noeFiSZ5a9aS8QR4pHkHz4zjDh/JglN4F7QFSLBLdnn54HHguq8oyg6VXQVMv6IA6\nnFv4wcypyjO+wRktwW+pklpoIuPaTNbHykBTjWD+Ew82iEIzh2m9j43UdGM+Kfmh\nGUSCYorwZG41v2GyepnCDWC5H3RslmxZ6+e9XcXdAoGALz3GAS93GEWRtwZi1Cei\nqhJYDGHEmojlprNDL4IC17hhk5p0wQ0cuZN+xt/B6w5jq4M6sJ4H0IMR0VtQcfnT\nQ49TDFvJnigLobH2zVLn6JqX9hFs8V+dR+OYz6kvrtrQr0nOfwK/oLI6E7xKKRDW\nKu6S0dFUE84TJ4M1hFeBhekCgYEAnYX9vBZ7PXMIlECiadKjxHYCKBwgTUlWpcpU\no+MdWFBpf6q1tbjk6rmu5Zb1SAjGw3jUbBnobFzvLo9vMGcJ7aWjT8PhpwfbUzI5\njmmpklTRcPrGJqXfwD4bdoxwUDa6tkgWXq0KA8ISmezBObREWDynECU38JmA7xih\n0PTSkpkCgYBUUASKsz2ThzQiAU+Ivu2Y/QON78N0ZyQ/0kDhxZ8AUnbtGZAOq5pV\nRMj053t5oJMr2eWkMZ5aBYmjo0Uy4vrRCV6SXrlAs3YsN1mh1P+xGRRmX99xwalJ\n6dQaTBdtQ33MhY0+17EXr6WUGRZHIcFM6uGa32MKSmeqkATuV7eyzg==\n-----END RSA PRIVATE KEY-----\n"
        server_user_public_key =   OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n"
        current_user = OpenStruct.new id: 1, public_key: current_user_public_key
        server_user = OpenStruct.new id: 2, public_key: server_user_public_key
        secret = Duse::Client::CreateSecret.with(
          title: 'test',
          secret_text: plaintext,
          users: [current_user, server_user]
        ).sign_with(current_user_private_key).build

        shares = secret[:shares].map { |s| Duse::Client::Share.new(s) }
        server_share = Duse::Encryption::Asymmetric.decrypt(server_user_private_key, shares[1].content)
        shares[1].content, _ = Duse::Encryption::Asymmetric.encrypt(current_user_private_key, current_user_public_key, server_share)

        secret = Duse::Client::Secret.new shares: shares, cipher_text: secret[:cipher_text]
        decrypted_secret = secret.decrypt(current_user_private_key)

        expect(decrypted_secret).to eq plaintext
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

  describe 'update process' do
    context 'changin users' do
      it 'leaves the cipher text unchanged and generates new shares' do
        stub_secret_get
        current_user_private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"
        current_user_public_key =  OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n"
        server_user_private_key =  OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAvyvyAf7lnVx9eQcAS7JLYRHrqJJe51rAdanaUiiy8eek2Iyh\n6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/pcxutggTWCnUQUvXmEEm5qZ1KOIIl\nEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc8w+02wpcmWuzWKjoY/G5KV33UDz/\nLxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/7DyXIuiBosVpj9E9T4kpxs3/7RmU\nfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mbSVO6yf2YOcrPDRa3pgz7PIr225QJ\n+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SOpQIDAQABAoIBAQCHXFJrX1St64Nc\nYryu3HvLK6k1Hw7bucJ0jePsMK0j4+Uw/8LUrfp380ZOsYeTZ2IzZiaXl6v9x9St\nFbKXYb3mpz5fxZTYqrL4Suyvs8QmeRzIjj44obYmD4yKz2BoHPfBVkUgyZ5Uayl3\nRQX0aqbr478nKVsPttayfEawHcQBqTHPE9dfavuT14/64iqkrIya4ejFVXd1vYG2\nx+oKedPAnD3jr9foEHTqj1D4AeORwonbxFllh3K91IcabV3zdIZH0ICvYaaryceU\n2npp1H0mqETMZ97o3uMo8S5AEK7TsyB26WlD1IUSfwaP3apkog2WMNvgU4c2OD/q\nX8l3mA2BAoGBAOHGaZtBXQUSUD95eQAG/03F1Non21dD+aUtMbDn1Li6aOD+C+a4\ncJVZ+D2nMMIoQz3nEBIVoEdK4prugQXZJ87pvWwpZ/afRmTNSYWHnJmmg5/rvrZ5\nuvR17DwmS5ucTVOWcdryoG0O5KZqyAnpshLecr5PALY+cfG+fjo6KxNpAoGBANjD\noeFiSZ5a9aS8QR4pHkHz4zjDh/JglN4F7QFSLBLdnn54HHguq8oyg6VXQVMv6IA6\nnFv4wcypyjO+wRktwW+pklpoIuPaTNbHykBTjWD+Ew82iEIzh2m9j43UdGM+Kfmh\nGUSCYorwZG41v2GyepnCDWC5H3RslmxZ6+e9XcXdAoGALz3GAS93GEWRtwZi1Cei\nqhJYDGHEmojlprNDL4IC17hhk5p0wQ0cuZN+xt/B6w5jq4M6sJ4H0IMR0VtQcfnT\nQ49TDFvJnigLobH2zVLn6JqX9hFs8V+dR+OYz6kvrtrQr0nOfwK/oLI6E7xKKRDW\nKu6S0dFUE84TJ4M1hFeBhekCgYEAnYX9vBZ7PXMIlECiadKjxHYCKBwgTUlWpcpU\no+MdWFBpf6q1tbjk6rmu5Zb1SAjGw3jUbBnobFzvLo9vMGcJ7aWjT8PhpwfbUzI5\njmmpklTRcPrGJqXfwD4bdoxwUDa6tkgWXq0KA8ISmezBObREWDynECU38JmA7xih\n0PTSkpkCgYBUUASKsz2ThzQiAU+Ivu2Y/QON78N0ZyQ/0kDhxZ8AUnbtGZAOq5pV\nRMj053t5oJMr2eWkMZ5aBYmjo0Uy4vrRCV6SXrlAs3YsN1mh1P+xGRRmX99xwalJ\n6dQaTBdtQ33MhY0+17EXr6WUGRZHIcFM6uGa32MKSmeqkATuV7eyzg==\n-----END RSA PRIVATE KEY-----\n"
        server_user_public_key =   OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n"
        current_user = OpenStruct.new id: 1, public_key: current_user_public_key
        server_user = OpenStruct.new id: 2, public_key: server_user_public_key
        secret = Duse::Secret.find(1)
        secret_hash = Duse::Client::UpdateSecret.values(
          secret,
          { users: [current_user, server_user] }
        ).encrypt_with(current_user_private_key).build

        shares = secret_hash[:shares].map { |s| Duse::Client::Share.new(s) }
        server_share = Duse::Encryption::Asymmetric.decrypt(server_user_private_key, shares[1].content)
        shares[1].content, _ = Duse::Encryption::Asymmetric.encrypt(current_user_private_key, current_user_public_key, server_share)

        new_secret = Duse::Client::Secret.new shares: shares, cipher_text: secret.cipher_text
        decrypted_secret = new_secret.decrypt(current_user_private_key)

        expect(decrypted_secret).to eq 'test'
        expect(new_secret.shares).not_to eq secret.shares
      end
    end
  end
end

