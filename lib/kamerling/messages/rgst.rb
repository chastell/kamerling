module Kamerling module Messages class RGST
  def initialize input
    @input = input
  end

  def == other
    input == other.input
  end

  def client_uuid
    input[16..31]
  end

  def project_uuid
    input[32..48]
  end

  def type
    input[0..3]
  end

  attr_reader :input
  protected   :input
end end end
