describe 'duse login', :fs => :fake do
  before :each do
    FileUtils.mkdir_p Duse::CLIConfig.config_dir
    open(Duse::CLIConfig.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
    end
  end

  context 'correct credentials' do
    it 'writes the auth token in the config file' do
      open(File.join(Duse::CLIConfig.config_dir, 'flower-pot'), 'w') do |f|
        f.puts "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"
      end
      stub_user_me_get
      stub_request(:post, "https://example.com/users/token").
        with(body: {username: "flower-pot", password: "Passw0rd!"}.to_json,
             headers: {'Accept'=>'application/vnd.duse.1+json', 'Content-Type'=>'application/json'}).
        to_return(status: 201, body: { api_token: 'token' }.to_json, headers: {})

      expect(run_cli('login') do |i|
        i.puts 'flower-pot'
        i.puts 'Passw0rd!'
      end.success?).to be true

      expect(File.read Duse::CLIConfig.config_file).to eq(
        "---\nuri: https://example.com/\ntoken: token\n"
      )
    end
  end

  context 'incorrect credentials' do
    it 'errors with a message' do
      stub_request(:post, "https://example.com/users/token").
        with(body: {username: "flower-pot", password: "wrong password"}.to_json,
             headers: {'Accept'=>'application/vnd.duse.1+json', 'Content-Type'=>'application/json'}).
        to_return(status: 401, body: "", headers: {})

      expect(run_cli('login') do |i|
        i.puts 'flower-pot'
        i.puts 'wrong password'
      end.err).to eq(
        "Wrong username or password!\n"
      )

      expect(File.read Duse::CLIConfig.config_file).to eq(
        "---\nuri: https://example.com/\n"
      )
    end
  end
end
