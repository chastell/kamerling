require 'securerandom'

module Kamerling
  module UUID
    module_function

    def [](bin)
      bin.unpack('H8H4H4H4H12').join('-')
    end

    def bin(string)
      [string.tr('-', '')].pack('H*')
    end

    def new
      SecureRandom.uuid
    end

    def zero
      self["\0" * 16]
    end
  end
end
