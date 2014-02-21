require 'after_do'
require 'logger'

module Kamerling class Logging
  def initialize logger: Logger.new($stdout)
    Server::TCP.extend AfterDo
    Server::TCP.before :start do |*, server|
      logger.info "start #{server.addr}"
    end
    Server::TCP.after :stop do |*, server|
      logger.info "stop #{server.addr}"
    end
  end
end end