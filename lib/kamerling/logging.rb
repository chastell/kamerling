require 'after_do'
require 'logger'

module Kamerling module Logging
  module_function

  def log_to logger: Logger.new($stdout)
    log_dispatcher_to logger
    log_server_to     logger
  end

  class << self
    private

    def log_dispatcher_to logger
      NetDispatcher.singleton_class.extend AfterDo
      NetDispatcher.singleton_class.before :dispatch do |addr, bytes|
        logger.debug "sent #{addr} #{bytes}"
      end
    end

    def log_server_to logger
      Server::Sock.extend AfterDo
      Server::Sock.before(:start) { |srv| logger.info "start #{srv.addr}" }
      Server::Sock.after(:stop)   { |srv| logger.info "stop #{srv.addr}"  }
      Server::Sock.before :handle do |input, client_addr|
        logger.info "connect #{client_addr}"
        logger.debug "received #{client_addr} #{input}"
      end
    end
  end
end end
