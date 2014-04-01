require 'after_do'
require 'logger'

module Kamerling class Logging
  def self.log_to logger = Logger.new($stdout)
    new logger
  end

  def initialize logger
    @logger = logger
    log_dispatcher
    log_server
  end

  attr_reader :logger
  private     :logger

  private

  def log_dispatcher
    NetDispatcher.singleton_class.extend AfterDo
    NetDispatcher.singleton_class.before :dispatch do |addr, bytes|
      logger.debug "sent #{addr} #{bytes}"
    end
  end

  def log_server
    Server::Sock.extend AfterDo
    Server::Sock.before(:start) { |srv| logger.info "start #{srv.addr}" }
    Server::Sock.after(:stop)   { |srv| logger.info "stop #{srv.addr}"  }
    Server::Sock.before :handle do |input, client_addr|
      logger.info "connect #{client_addr}"
      logger.debug "received #{client_addr} #{input}"
    end
  end
end end
