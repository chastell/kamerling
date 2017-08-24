require_relative 'addr'

module Kamerling
  class TCPAddr < Addr
    def self.[](host, port)
      new(host: host, port: port, prot: :TCP)
    end
  end
end
