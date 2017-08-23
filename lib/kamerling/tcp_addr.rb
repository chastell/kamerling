require 'uri'
require_relative 'addr'

module Kamerling
  class TCPAddr < Addr
    def self.[](string)
      uri = URI.parse("tcp://#{string}")
      new(host: uri.host, port: uri.port, prot: :TCP)
    end
  end
end
