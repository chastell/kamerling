# frozen_string_literal: true

require 'socket'
require_relative '../addr'
require_relative 'sock'

module Kamerling
  module Server
    class UDP < Sock
      def self.default_addr
        Addr[ENV['HOST'], ENV['UDP'], :UDP]
      end

      private

      def handle_connection(socket)
        input, conn = socket.recvfrom 2**16
        addr = Addr[conn[3], conn[1], :UDP]
        handle input, addr: addr
      end

      def run_loop
        socket = UDPSocket.new.tap { |server| server.bind(*addr) }
        loop { handle_connection socket if IO.select [socket] }
      ensure
        socket&.close
      end

      def wait_till_started
        200.times { thread.run }
      end
    end
  end
end
