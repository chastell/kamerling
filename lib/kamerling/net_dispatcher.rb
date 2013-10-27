module Kamerling class NetDispatcher
  def dispatch addr, bytes
    case addr.prot
    when :TCP then TCPSocket.open(*addr) { |socket| socket << bytes }
    when :UDP then UDPSocket.new.send bytes, 0, *addr
    end
  end
end end
