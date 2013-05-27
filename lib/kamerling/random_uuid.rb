module Kamerling module RandomUUID
  extend self

  def random_uuid
    [SecureRandom.uuid.tr('-', '')].pack 'H*'
  end
end end
