# frozen_string_literal: true

require 'optparse'
require 'sequel'
require_relative 'addr'
require_relative 'value'

module Kamerling
  class Settings < Value
    vals db: String, host: String, http: Integer, tcp: Integer, udp: Integer
    defaults db: 'sqlite::memory:', host: '127.0.0.1'

    def self.from_args(args)
      new(parse(args))
    end

    def db_conn
      Sequel.connect(db)
    end

    def http_addr
      Addr[host, http, :TCP] if http
    end

    def server_addrs
      {
        http: Addr[host, http, :TCP],
        tcp:  Addr[host, tcp,  :TCP],
        udp:  Addr[host, udp,  :UDP],
      }.select { |_, addr| addr.port }
    end

    private_class_method def self.default_db
      attribute_set[:db].default_value.value
    end

    private_class_method def self.default_host
      attribute_set[:host].default_value.value
    end

    private_class_method def self.parse(args)
      {}.tap do |hash|
        OptionParser.new do |opt|
          opt.on("--db #{default_db}", String)     { |db|   hash[:db]   = db   }
          opt.on("--host #{default_host}", String) { |host| hash[:host] = host }
          opt.on('--http 0', Integer, 'HTTP port') { |http| hash[:http] = http }
          opt.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  hash[:tcp]  = tcp  }
          opt.on('--udp 0',  Integer, 'UDP port')  { |udp|  hash[:udp]  = udp  }
        end.parse args
      end
    end
  end
end
