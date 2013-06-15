require 'securerandom'

module Kamerling module UUID
  def self.[] bin
    bin.unpack('H8H4H4H4H12').join '-'
  end

  def self.bin uuid
    [uuid.tr('-', '')].pack 'H*'
  end

  def self.new
    SecureRandom.uuid
  end
end end
