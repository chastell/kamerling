require 'optparse'

module Kamerling class ServerRunner
  def initialize args, classes: def_classes, orm: Sequel, repos: Repos
    @args    = args
    repos.db = orm.connect settings.db
    @servers = { http: :TCP, tcp: :TCP, udp: :UDP }.map do |type, prot|
      addr = Addr[settings.host, settings.send(type), prot]
      classes[type].new addr: addr if addr.port
    end.compact
  end

  def join
    servers.each(&:join)
  end

  def start
    servers.each(&:start)
    self
  end

  attr_reader :args, :servers
  private     :args, :servers

  private

  Settings = Struct.new(*%i(db host http tcp udp))

  def def_classes
    { http: Server::HTTP, tcp: Server::TCP, udp: Server::UDP }
  end

  def defaults
    Settings.new 'sqlite::memory:', '127.0.0.1'
  end

  def settings
    @settings ||= defaults.tap do |set|
      OptionParser.new do |opt|
        opt.on("--db #{set.db}", String, 'database') { |db| set.db = db }
        opt.on("--host #{set.host}", String, 'host') { |host| set.host = host }
        opt.on('--http 0', Integer, 'HTTP port') { |http| set.http = http }
        opt.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  set.tcp  = tcp  }
        opt.on('--udp 0',  Integer, 'UDP port')  { |udp|  set.udp  = udp  }
      end.parse! args
    end
  end
end end
