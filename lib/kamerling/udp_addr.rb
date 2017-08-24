require_relative 'addr'

module Kamerling
  class UDPAddr < Addr
    def self.[](host, port)
      new(host: host, port: port, prot: :UDP)
    end
  end
end
