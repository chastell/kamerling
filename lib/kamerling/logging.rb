require 'after_do'
require 'logger'
require_relative 'net_dispatcher'
require_relative 'server/sock'

module Kamerling
  class Logging
    def self.log_to(logger = Logger.new($stdout))
      new logger
    end

    def initialize(logger)
      @logger = logger
      log_dispatcher
      log_server
    end

    private

    attr_reader :logger

    def log_dispatcher
      NetDispatcher.singleton_class.extend AfterDo
      NetDispatcher.singleton_class.before(:dispatch) do |bytes, kwargs|
        logger.debug "sent #{kwargs[:addr]} #{Message.new(bytes).to_hex}"
      end
    end

    def log_server
      Server::Sock.extend AfterDo
      log_server_lifecycle
      log_server_communication
    end

    def log_server_communication
      Server::Sock.before(:handle) do |input, kwargs|
        addr = kwargs[:addr]
        begin
          logger.info "connect #{addr}"
          logger.debug "received #{addr} #{Message.new(input).to_hex}"
        rescue Message::UnknownType
          logger.debug "received #{addr} unknown message type"
        end
      end
    end

    def log_server_lifecycle
      Server::Sock.before(:start) { |*_, srv| logger.info "start #{srv.addr}" }
      Server::Sock.after(:stop)   { |*_, srv| logger.info "stop #{srv.addr}"  }
    end
  end
end
