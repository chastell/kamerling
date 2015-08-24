require 'optparse'
require_relative 'addr'
require_relative 'value'

module Kamerling
  class Settings < Value
    vals db: String, host: String, http: Integer, tcp: Integer, udp: Integer

    def self.from_args(args)
      new(parse(args))
    end

    def self.parse(args)
      { db: 'sqlite::memory:', host: '127.0.0.1' }.tap do |hash|
        OptionParser.new do |opt|
          opt.on("--db #{hash[:db]}", String)      { |db|   hash[:db]   = db   }
          opt.on("--host #{hash[:host]}", String)  { |host| hash[:host] = host }
          opt.on('--http 0', Integer, 'HTTP port') { |http| hash[:http] = http }
          opt.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  hash[:tcp]  = tcp  }
          opt.on('--udp 0',  Integer, 'UDP port')  { |udp|  hash[:udp]  = udp  }
        end.parse args
      end
    end

    def server_addrs
      {
        http: Addr[host, http, :TCP],
        tcp:  Addr[host, tcp,  :TCP],
        udp:  Addr[host, udp,  :UDP],
      }.select { |_, addr| addr.port }
    end
  end
end
