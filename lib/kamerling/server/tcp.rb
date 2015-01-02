require 'socket'
require_relative '../addr'
require_relative 'sock'

module Kamerling
  module Server
    class TCP < Sock
      private

      def handle_connection(socket)
        addr  = Addr[*socket.remote_address.ip_unpack, :TCP]
        input = socket.read
        handle input, addr
      ensure
        socket.close
      end

      def run_loop
        Socket.tcp_server_loop(*addr) { |socket| handle_connection socket }
      end

      def wait_till_started
        loop { break if addr.connectable? }
      end
    end
  end
end
