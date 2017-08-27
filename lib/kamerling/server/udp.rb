# frozen_string_literal: true

require 'socket'
require_relative '../udp_addr'
require_relative 'sock'

module Kamerling
  module Server
    class UDP < Sock
      def self.default_addr
        UDPAddr[ENV['HOST'], ENV['UDP']]
      end

      private

      # :reek:FeatureEnvy
      def handle_connection(socket)
        input, conn = socket.recvfrom 2**16
        addr = UDPAddr[conn[3], conn[1]]
        handle input, addr: addr
      end

      # :reek:ManualDispatch
      def run_loop
        socket = UDPSocket.new.tap { |server| server.bind(*addr) }
        loop { handle_connection socket if IO.select [socket] }
      ensure
        socket.close if socket.respond_to?(:close)
      end

      def wait_till_started
        200.times { thread.run }
      end
    end
  end
end
