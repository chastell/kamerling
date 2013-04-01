module Kamerling class Message
  def initialize input
    @input = input
  end

  def == other
    input == other.input
  end

  def client_uuid
    input[16..31]
  end

  def data
    input[64..-1]
  end

  def project_uuid
    input[32..47]
  end

  def task_uuid
    input[48..63]
  end

  def type
    input[0..3]
  end

  attr_reader :input
  protected   :input
end end