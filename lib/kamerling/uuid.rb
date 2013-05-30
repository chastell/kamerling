module Kamerling module UUID
  def self.new
    SecureRandom.uuid
  end
end end
