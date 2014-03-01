require 'after_do'
require 'logger'

module Kamerling module Logging
  module_function

  def log_to logger: Logger.new($stdout)
    add_server_logging logger
    add_dispatcher_logging logger
  end

  private

  def self.add_dispatcher_logging logger
    NetDispatcher.extend AfterDo
    NetDispatcher.before :dispatch do |addr, bytes|
      logger.debug "sent #{addr} #{bytes}"
    end
  end

  def self.add_server_logging logger
    Server::Sock.extend  AfterDo
    Server::Sock.before(:start) { |server| logger.info "start #{server.addr}" }
    Server::Sock.after(:stop)   { |server| logger.info "stop #{server.addr}"  }
    Server::Sock.before :handle do |input, client_addr|
      logger.info "connect #{client_addr}"
      logger.debug "received #{client_addr} #{input}"
    end
  end
end end
