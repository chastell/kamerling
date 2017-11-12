require 'forwardable'
require 'rack'
require_relative '../http_api'
require_relative '../tcp_addr'

module Kamerling
  module Server
    class HTTP
      extend Forwardable

      attr_reader :addr

      def initialize(addr: TCPAddr[ENV['HOST'], ENV['HTTP']])
        @addr = addr
      end

      def ==(other)
        addr == other.addr
      end

      delegate join: :thread

      def start
        @thread = Thread.new do
          Rack::Handler::WEBrick.run HTTPAPI, Host: addr.host, Port: addr.port
        end
        loop { break if addr.connectable? }
        self
      end

      def stop
        thread.exit.join
      end

      private

      attr_reader :thread
    end
  end
end
