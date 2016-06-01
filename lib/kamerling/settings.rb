# frozen_string_literal: true

require 'forwardable'
require 'optparse'
require 'sequel'
require_relative 'addr'
require_relative 'client_repo'
require_relative 'dispatch_repo'
require_relative 'project_repo'
require_relative 'registration_repo'
require_relative 'result_repo'
require_relative 'task_repo'
require_relative 'value'

module Kamerling
  class Settings < Value
    vals db: String, host: String, http: Integer, tcp: Integer, udp: Integer
    defaults db: 'sqlite::memory:', host: '127.0.0.1'

    extend Forwardable

    def self.from_args(args)
      new(parse(args))
    end

    delegate %i(client_repo dispatch_repo project_repo registration_repo
                result_repo task_repo) => :repos

    def servers
      [
        Server::HTTP.new(addr: Addr[host, http, :TCP]),
        Server::TCP.new(addr:  Addr[host, tcp, :TCP]),
        Server::UDP.new(addr:  Addr[host, udp, :UDP]),
      ].select { |server| server.addr.port }
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

    private

    def repos
      @repos ||= Repos.new(db)
    end

    class Repos
      def initialize(db = 'sqlite::memory:')
        @db_conn = Sequel.connect(db)
      end

      def client_repo
        ClientRepo.new(db_conn)
      end

      def dispatch_repo
        DispatchRepo.new(db_conn)
      end

      def project_repo
        ProjectRepo.new(db_conn)
      end

      def registration_repo
        RegistrationRepo.new(db_conn)
      end

      def result_repo
        ResultRepo.new(db_conn)
      end

      def task_repo
        TaskRepo.new(db_conn)
      end

      private

      attr_reader :db_conn
    end
  end
end
