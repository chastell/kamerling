# frozen_string_literal: true

require 'dotenv'
Dotenv.load

require 'optparse'
require_relative 'addr'
require_relative 'repos'
require_relative 'value'

module Kamerling
  class Settings < Value
    vals host: String, http: Integer, tcp: Integer, udp: Integer
    defaults host: '127.0.0.1', http: ENV['HTTP'], tcp: ENV['TCP'],
             udp: ENV['UDP']

    def self.from_args(args)
      new(parse(args))
    end

    def servers
      [
        Server::HTTP.new(addr: Addr[host, http, :TCP]),
        Server::TCP.new(addr:  Addr[host, tcp, :TCP]),
        Server::UDP.new(addr:  Addr[host, udp, :UDP]),
      ].select { |server| server.addr.port }
    end

    private_class_method def self.default_host
      attribute_set[:host].default_value.value
    end

    private_class_method def self.parse(args)
      {}.tap do |hash|
        OptionParser.new do |opt|
          opt.on("--host #{default_host}", String) { |host| hash[:host] = host }
          opt.on('--http 0', Integer, 'HTTP port') { |http| hash[:http] = http }
          opt.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  hash[:tcp]  = tcp  }
          opt.on('--udp 0',  Integer, 'UDP port')  { |udp|  hash[:udp]  = udp  }
        end.parse args
      end
    end
  end
end
