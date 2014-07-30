require 'optparse'
require_relative 'addr'
require_relative 'value'

module Kamerling
  class Settings < Value
    vals db: String, host: String, http: Integer, tcp: Integer, udp: Integer

    def initialize args
      super db: 'sqlite::memory:', host: '127.0.0.1'
      OptionParser.new do |opt|
        opt.on("--db #{db}", String, 'database') { |db|   self.db   = db   }
        opt.on("--host #{host}", String, 'host') { |host| self.host = host }
        opt.on('--http 0', Integer, 'HTTP port') { |http| self.http = http }
        opt.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  self.tcp  = tcp  }
        opt.on('--udp 0',  Integer, 'UDP port')  { |udp|  self.udp  = udp  }
      end.parse! args
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
