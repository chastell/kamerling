require 'securerandom'

module Kamerling
  module UUID
    module_function

    def [](bin)
      bin.unpack('H8H4H4H4H12').join '-'
    end

    def bin(uuid)
      [uuid.tr('-', '')].pack 'H*'
    end

    def new
      SecureRandom.uuid
    end
  end
end
