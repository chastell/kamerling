# frozen_string_literal: true

require 'socket'
require_relative '../tcp_addr'
require_relative 'sock'

module Kamerling
  module Server
    class TCP < Sock
      def self.default_addr
        TCPAddr[ENV['HOST'], ENV['TCP']]
      end

      private

      # :reek:FeatureEnvy
      def handle_connection(socket)
        addr  = TCPAddr[*socket.remote_address.ip_unpack]
        input = socket.read
        handle input, addr: addr
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
