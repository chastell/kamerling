require 'optparse'

module Kamerling class ServerRunner
  Settings = Struct.new(*%i[db host http tcp udp])

  def initialize args, classes: classes, logger: Logger.new('/dev/null'),
                 orm: Sequel, repos: Repos
    @args    = args
    repos.db = orm.connect settings.db
    @servers = { http: :TCP, tcp: :TCP, udp: :UDP }.map do |type, prot|
      addr = Addr[settings.host, settings.send(type), prot]
      classes[type].new addr: addr, logger: logger if addr.port
    end.compact
  end

  def join
    servers.each(&:join)
  end

  def start
    servers.each(&:start)
  end

  attr_reader :args, :servers
  private     :args, :servers

  private

  def classes
    { http: Server::HTTP, tcp: Server::TCP, udp: Server::UDP }
  end

  def settings
    @settings ||= Settings.new.tap do |sets|
      sets.db   = 'sqlite::memory:'
      sets.host = '127.0.0.1'
      OptionParser.new do |opts|
        opts.on("--db #{sets.db}", String, 'database') do |db|
          sets.db = db
        end
        opts.on("--host #{sets.host}", String, 'server host') do |host|
          sets.host = host
        end
        opts.on('--http 0', Integer, 'HTTP port') { |http| sets.http = http }
        opts.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  sets.tcp  = tcp  }
        opts.on('--udp 0',  Integer, 'UDP port')  { |udp|  sets.udp  = udp  }
      end.parse! args
    end
  end
end end
