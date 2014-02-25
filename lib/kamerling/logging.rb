require 'after_do'
require 'logger'

module Kamerling class Logging
  def initialize logger: Logger.new($stdout)
    Server::Sock.extend AfterDo
    Server::Sock.before :start do |*, server|
      logger.info "start #{server.addr}"
    end
    Server::Sock.before :handle do |input, client_addr|
      logger.info "connect #{client_addr}"
      logger.debug "received #{client_addr} #{input}"
    end
    Server::Sock.after :stop do |*, server|
      logger.info "stop #{server.addr}"
    end
  end
end end
