require 'digest'

module ApiCore
  class Base
    class << self
      # Generate a friendly string randomically to be used as token.
      def friendly_token
        SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
      end

      def hex_token(length = 32)
        SecureRandom.hex length
      end

      def friendly_pin(digits = 4)
        (0...digits).collect { rand(9) }.join
      end

      def md5(string)
        Digest::MD5.hexdigest(string)
      end

      # constant-time comparison algorithm to prevent timing attacks
      def secure_compare(a, b)
        return false if a.blank? || b.blank? || a.bytesize != b.bytesize
        l = a.unpack "C#{a.bytesize}"
        res = 0
        b.each_byte { |byte| res |= byte ^ l.shift }
        res.zero?
      end

      def build_sign(args = [])
        args.any? ? md5(args.join) : md5(hex_token)
      end
    end
  end
end
