require 'after_do'
require 'logger'

module Kamerling class Logging
  def initialize logger: Logger.new($stdout)
    Server::TCP.extend AfterDo
    Server::TCP.before :start do |*, server|
      logger.info "start #{server.addr}"
    end
    Server::TCP.before :handle_connection do |socket|
      client_addr = Addr[*socket.remote_address.ip_unpack, :TCP]
      logger.info "connect #{client_addr}"
    end
    Server::TCP.before :handle do |input, client_addr|
      logger.debug "received #{client_addr} #{input}"
    end
    Server::TCP.after :stop do |*, server|
      logger.info "stop #{server.addr}"
    end
    Server::UDP.extend AfterDo
    Server::UDP.before :start do |*, server|
      logger.info "start #{server.addr}"
    end
    Server::UDP.after :stop do |*, server|
      logger.info "stop #{server.addr}"
    end
  end
end end
