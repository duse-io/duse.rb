require 'openssl'

module KeyHelper
  def server_private_key
    OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAvyvyAf7lnVx9eQcAS7JLYRHrqJJe51rAdanaUiiy8eek2Iyh\n6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/pcxutggTWCnUQUvXmEEm5qZ1KOIIl\nEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc8w+02wpcmWuzWKjoY/G5KV33UDz/\nLxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/7DyXIuiBosVpj9E9T4kpxs3/7RmU\nfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mbSVO6yf2YOcrPDRa3pgz7PIr225QJ\n+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SOpQIDAQABAoIBAQCHXFJrX1St64Nc\nYryu3HvLK6k1Hw7bucJ0jePsMK0j4+Uw/8LUrfp380ZOsYeTZ2IzZiaXl6v9x9St\nFbKXYb3mpz5fxZTYqrL4Suyvs8QmeRzIjj44obYmD4yKz2BoHPfBVkUgyZ5Uayl3\nRQX0aqbr478nKVsPttayfEawHcQBqTHPE9dfavuT14/64iqkrIya4ejFVXd1vYG2\nx+oKedPAnD3jr9foEHTqj1D4AeORwonbxFllh3K91IcabV3zdIZH0ICvYaaryceU\n2npp1H0mqETMZ97o3uMo8S5AEK7TsyB26WlD1IUSfwaP3apkog2WMNvgU4c2OD/q\nX8l3mA2BAoGBAOHGaZtBXQUSUD95eQAG/03F1Non21dD+aUtMbDn1Li6aOD+C+a4\ncJVZ+D2nMMIoQz3nEBIVoEdK4prugQXZJ87pvWwpZ/afRmTNSYWHnJmmg5/rvrZ5\nuvR17DwmS5ucTVOWcdryoG0O5KZqyAnpshLecr5PALY+cfG+fjo6KxNpAoGBANjD\noeFiSZ5a9aS8QR4pHkHz4zjDh/JglN4F7QFSLBLdnn54HHguq8oyg6VXQVMv6IA6\nnFv4wcypyjO+wRktwW+pklpoIuPaTNbHykBTjWD+Ew82iEIzh2m9j43UdGM+Kfmh\nGUSCYorwZG41v2GyepnCDWC5H3RslmxZ6+e9XcXdAoGALz3GAS93GEWRtwZi1Cei\nqhJYDGHEmojlprNDL4IC17hhk5p0wQ0cuZN+xt/B6w5jq4M6sJ4H0IMR0VtQcfnT\nQ49TDFvJnigLobH2zVLn6JqX9hFs8V+dR+OYz6kvrtrQr0nOfwK/oLI6E7xKKRDW\nKu6S0dFUE84TJ4M1hFeBhekCgYEAnYX9vBZ7PXMIlECiadKjxHYCKBwgTUlWpcpU\no+MdWFBpf6q1tbjk6rmu5Zb1SAjGw3jUbBnobFzvLo9vMGcJ7aWjT8PhpwfbUzI5\njmmpklTRcPrGJqXfwD4bdoxwUDa6tkgWXq0KA8ISmezBObREWDynECU38JmA7xih\n0PTSkpkCgYBUUASKsz2ThzQiAU+Ivu2Y/QON78N0ZyQ/0kDhxZ8AUnbtGZAOq5pV\nRMj053t5oJMr2eWkMZ5aBYmjo0Uy4vrRCV6SXrlAs3YsN1mh1P+xGRRmX99xwalJ\n6dQaTBdtQ33MhY0+17EXr6WUGRZHIcFM6uGa32MKSmeqkATuV7eyzg==\n-----END RSA PRIVATE KEY-----\n"
  end

  def server_public_key
    OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n"
  end

  def user_private_key
    OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAmMm3Ovh7gU0rLHK4NiHhWaYRrV9PH6XtHqV0GoiHH7awrjVk\nT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ7FLTWMZNoZ/uh41g4Iv17Wh1I3Fg\nqihdm83cSWvJ81qQCVGBaKeVitSa49zT/MmooBvYFwulaqJjhqFc3862Rl3WowzG\nVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1nng06HIAvMqUcGMebgoju9SuKaR+C\n46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHSI9hTEuPopPSyRqz/EVQfbhi0Lbkd\nDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7AwIDAQABAoIBAQCGSVyLLxRWC/4z\nPc0cfuCyy5xj1g4UEeD7+421OGQTAp39L54vgTzG76SJL/hIsn660b46ZL7BxUd8\nPiK2Mi/C1fU95GUc9hVO/Hq2QS1wcUvrT94XEA1eQCwqN9uy0Nkh54om8owkDkLo\nnRGQ76kOuApQDwNfWsTA8phPeT6JTtr+2K2yc0H4G5G0+py2GDclq56E99SljAqq\nwjFKGazqF0pxJvqLRCR9uVt0FgrRANOLGvxPMNZtnkVBVHmXs1iRD7BUALfESGS1\nHXZxjvD487E2h0Vjkli7rqnu6FZNgQ8Mq5TOfIm5i04LeGCgSTNP9sw7vdZgaYgT\nDPK9BIlZAoGBAMlhenDUOkT1dm28CjGCkygM1kUgDTQDLyBXW/JacotRp3GVZLr2\nV/2rZ3JPxva0cjjs3X4q/CxYsHvqI/ImXbsTBOYIT1/y1fgmXvN6AbiVW5Qne1UD\nneEGqCyB6YfKV2/8CX5Ru01Ay1EYVQDU4APkR1P4H38CuTMeu8SHK/BHAoGBAMI6\nR6TeEIdLprWRmUKU8Iuiwwm0SVxle2trSj6mknsJ93sK7gQkoKNzw0qwZdM6ApKH\nbJo/LiwiZ1Znx1NOyDsKT/ET6CSl59jOBuSUoxqTJ8XvrWlSD8pkbOJ2zWF8WqFR\ncC74bNFgd+n0tftR/7dwkriebITrp5IpF6P2Z9llAoGAAqO3ciEl/l9lRPzw+UMn\n4J+Cc3d/FM5x4K+kceHDnJXeZvu5TUYLUzTa70Gibvtgf+SC5rNziLVE4urnu7XL\nBreyGb3EJJLPQShnmDNiMGQsxh1aXXvlptxqeeLeB7ycNsiL607w8ItH3vE9s/wW\nT5a/ZJdc+lIz0Tq25VWMOuMCgYAejVZZu8izz5WguA94pr8T5/1wGFj13MzGP/FE\n26TtD8tLIpQAONa//2S36fmKeXSQIhdWSBv2O08wC1ESbLEYgG3EyVHZ+fL3aqkw\n6aSieIVoIGSRzaPIPXXXRcLW093ZxFq2OMO9R8R1G9ZIe0STUXTy75C4c+0/E5Gx\nbAA39QKBgDLjtjmG3nJGpQuaftAAjJR+AcA3svSdVug7w5k6D+lxBeM/x4pGP9z4\nkdOrqeD6bv1cctouVVywK/ZQ8dyLczJoGfJIlCvacI1L7fyVUpBp2Lby/uwYMd5w\ngswew+6Xnvtx15SirvYQmDRzA71KBSA4GxpaFwthRIxIwn881m5U\n-----END RSA PRIVATE KEY-----\n"
  end

  def user_public_key
    OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n"
  end

  def other_private_key
    OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEA0Y1b9awjW0nshQXk64uO1v+GYliBH8ogu6QjQDn0eoLIfcOi\nbrotbhJuSS0G46yOhboOCZQWrwyqi4MYtTMBH3ITTmNkhzOkdRXLJGJXXv3OCYR0\nJ+PdCXbrtfYkvqOgyJE4RAR6YBEO/XcQk0EmE4IDFq22Aar7MxSjrLk17LX9mTif\ndzg1xdxX5myX4NrXGVWTWKeS5klLWCe9AigQ35b8c2Zyehx6jxHk+jt5CguMC9Vq\nSyJobKdu926W4k2AgzWRdZh0EvCg2wWjlYjchJEnrpHLeJxGMEThPoGqgQWiG5BB\nYIl9kx1vg1QZmS2biS6djGpGIn8l8PN30+QS5QIDAQABAoIBAQC3pXYRMOHvkDKr\nRcYgs7bkLx47tCq9jGvxZmDKWcArWdCRf1EsTxefXqGumbpu73wcMDk7JcBXevc/\nuw19R4zVXSkUSsEASD75qbbVVSYTBsV5y83sY6MEN2dNmcEMHeS7waEY4v/Ij0qe\n0akCFFdlQ0ynpGdcwNbTJmRm7A4ZOrLMoVTJaI/enRJcQSEzBkQ/oHpMlcDBoFJq\nIB61tfm5JD6IPM2BKlXvSOpV8ItPpJYG4PJxUDT7YEhrXy0vGHKyjaKoE04EdLvI\nvfEkP67if9BTR0tMP+dxaeZ8c9ydGCHC9p1rDJMdpGoS4gwBLueEkDxNEchtrf5p\nM+fPan5lAoGBAPR6YLODhK6YIl6M1EMxbXlytnwAwr5vJvMmRBiVyXLnXKoVFI8V\nHkPsjO6wUH8OjZjEflteoo7Co2pawvfUuPhtHPrWVpW8tAdIELGfazOnsdxvcIAJ\nTUB7tHSS/WeWEcsloCAOTb+6wjZdah9CDly95madbI1IYtz9s0Z/TPMXAoGBANtt\nmhAIxNs/8X9lDWbkbQRWdIr/sb6LCQcBN/Jc5mdz9Kp3sXu2Ag4aRsSPbbtu+XBY\nkl+aSIIYWlHJJE1kKKMDJ+cEpCdx8+kdhz/NIfAdbo3RsZ3cDy7ZM28iHNO4LVRX\ndu/VlBrm4CXCBdlug4+GhZK7on1YnPtrqldV7RdjAoGBALb6nUPejMEMdrTjnL8J\n0JEUjYZ0H03e7X0RR+hKu7L3fUCDdJa+zJ8z/itr5WOjZdFQR+5k/y/wd9TTR5es\nLCErsYQARl/eE7RbeLsowVixC4scEUyTKbG4pNCXb3hHNtwgNh+n9QMqac+8zP/G\nNe+t5jMpYiTAZ9ZVQAfkoZhTAoGAezIG7Hev5pT5Bph6tMkM+AF+P0gdyCgRcnBZ\ns+Y6qdytgkPfTuC6OKbCErugVTqSK2RfEfPyP7BijUaL7jOMqTEtZwPxEgBle/1L\nISQPqNstZcxUl5ekop3pxbx2SNw//vl4WmEkXRJAyJItbI0iqiNRvTdBnHRy9qnV\nImGo0pcCgYEA5SJk+Fx/9bJXyKEJIp/Q+Zjq5Oc/4Th9b8ydSBCeksoz9qF+5pWq\nWpDXCa1fdLUxXK+cG39VxF3w2pok5NASeTgF+0myUofc8z/+K/qCDCn8wbojCZpi\nJwB1XlU0M+ZV9emAI1L1DGtoz7i8LT0uG8U5wWFZNljI3GXhfOYpWD4=\n-----END RSA PRIVATE KEY-----\n"
  end

  def other_public_key
    OpenSSL::PKey::RSA.new "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Y1b9awjW0nshQXk64uO\n1v+GYliBH8ogu6QjQDn0eoLIfcOibrotbhJuSS0G46yOhboOCZQWrwyqi4MYtTMB\nH3ITTmNkhzOkdRXLJGJXXv3OCYR0J+PdCXbrtfYkvqOgyJE4RAR6YBEO/XcQk0Em\nE4IDFq22Aar7MxSjrLk17LX9mTifdzg1xdxX5myX4NrXGVWTWKeS5klLWCe9AigQ\n35b8c2Zyehx6jxHk+jt5CguMC9VqSyJobKdu926W4k2AgzWRdZh0EvCg2wWjlYjc\nhJEnrpHLeJxGMEThPoGqgQWiG5BBYIl9kx1vg1QZmS2biS6djGpGIn8l8PN30+QS\n5QIDAQAB\n-----END PUBLIC KEY-----\n"
  end
end
