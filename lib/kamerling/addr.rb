require 'socket'
require_relative 'value'

module Kamerling class Addr < Value
  vals host: String, port: Integer, prot: Symbol

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

  def uri
    "#{prot.downcase}://#{host}:#{port}"
  end
end end
