module Kamerling class NetDispatcher
  def initialize addr
    @addr = addr
  end

  def dispatch bytes
    case addr.prot
    when :TCP then TCPSocket.open(*addr) { |socket| socket << bytes }
    when :UDP then UDPSocket.new.send bytes, 0, *addr
    end
  end

  attr_reader :addr
  private     :addr
end end
