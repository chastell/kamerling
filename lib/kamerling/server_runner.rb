require 'optparse'

module Kamerling class ServerRunner
  Settings = Struct.new(*%i[host http tcp udp])

  def initialize args, classes: classes
    @args = args
    { http: :TCP, tcp: :TCP, udp: :UDP }.each do |type, prot|
      port = settings.send type
      if port
        servers << classes[type].new(addr: Addr[settings.host, port, prot])
      end
    end
  end

  def start
    servers.each(&:start)
  end

  attr_reader :args
  private     :args

  private

  def classes
    { http: Server::HTTP, tcp: Server::TCP, udp: Server::UDP }
  end

  def servers
    @servers ||= []
  end

  def settings
    @settings ||= Settings.new.tap do |sets|
      OptionParser.new do |opts|
        opts.on('--host 127.0.0.1', String, 'server host') do |host|
          sets.host = host
        end
        opts.on('--http 0', Integer, 'HTTP port') { |http| sets.http = http }
        opts.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  sets.tcp  = tcp  }
        opts.on('--udp 0',  Integer, 'UDP port')  { |udp|  sets.udp  = udp  }
      end.parse! args
    end
  end
end end
