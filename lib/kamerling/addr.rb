require 'socket'
require 'uri'
require_relative 'value'

module Kamerling
  class Addr < Value
    vals host: String, port: Integer, prot: Symbol
    defaults port: 0

    def self.[](host, port, prot)
      new(host: host, port: port, prot: prot)
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

    def to_s
      "#{prot.downcase}://#{host}:#{port}"
    end
  end
end
