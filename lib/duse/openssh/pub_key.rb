require 'openssl'
require 'base64'

# see http://stackoverflow.com/questions/3162155/convert-rsa-public-key-to-rsa-der
module OpenSSH
  class PubKey
    def initialize(ssh_pub_key)
      @ssh_pub_key = ssh_pub_key
    end

    def to_rsa
      asn1 = make_asn1(*decode_pub(@ssh_pub_key))
      # Let OpenSSL deal with converting from the simple ASN.1
      OpenSSL::PKey::RSA.new(asn1.to_der)
    end

    private

    def read_length(s)
      # four bytes, big-endian
      length = s[0..3].unpack('N')[0]
    end

    def read_integer(s, length)
      # shift all bytes into one integer
      s[4..3 + length].unpack('C*').inject { |n, b| (n << 8) + b }
    end

    def cut(s, length)
      s[4 + length..-1]
    end

    def decode_pub(pub)
      # the second field is the Base64 piece needed
      s = Base64.decode64(pub.split[1])

      # first field reading "ssh-rsa" is ignored
      i = read_length(s)
      s = cut(s, i)

      # public exponent e
      i = read_length(s)
      e = read_integer(s, i)
      s = cut(s, i)

      # modulus n
      i = read_length(s)
      n = read_integer(s, i)

      [ e, n ]
    end

    def make_asn1(e, n)
      # Simple RSA public key in ASN.1
      e0 = OpenSSL::ASN1::Integer.new(e)
      n1 = OpenSSL::ASN1::Integer.new(n)
      OpenSSL::ASN1::Sequence.new([ e0, n1 ])
    end
  end
end

