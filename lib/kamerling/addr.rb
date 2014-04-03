module Kamerling class Addr < Value
  values do
    attribute :host, String
    attribute :port, Integer
    attribute :prot, Symbol
  end

  def self.[] host, port, prot
    new host: host, port: port, prot: prot
  end

  def connectable?
    TCPSocket.open(*self).close
    true
  rescue Errno::ECONNREFUSED
    false
  end

  def to_a
    [host, port]
  end

  def to_h
    attributes.merge prot: prot.to_s
  end

  def to_s
    "#{host}:#{port} (#{prot})"
  end
end end
