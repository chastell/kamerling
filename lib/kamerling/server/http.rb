require 'rack'
require_relative '../http_api'

module Kamerling
  module Server
    class HTTP
      attr_reader :addr

      def initialize(addr:)
        @addr = addr
      end

      def join
        thread.join
      end

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

      private_attr_reader :thread
    end
  end
end
