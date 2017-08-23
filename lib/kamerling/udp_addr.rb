require 'uri'
require_relative 'addr'

module Kamerling
  class UDPAddr < Addr
    def self.[](string)
      uri = URI.parse("udp://#{string}")
      new(host: uri.host, port: uri.port, prot: :UDP)
    end
  end
end
