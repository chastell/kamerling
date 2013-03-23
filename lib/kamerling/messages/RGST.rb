module Kamerling module Messages class RGST
  def == other
    other.class == self.class
  end

  def type
    'RGST'
  end
end end end
