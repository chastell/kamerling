# frozen_string_literal: true

require_relative '../handler'
require_relative '../message'

module Kamerling
  module Server
    class Sock
      attr_reader :addr

      def initialize(addr:, handler: Handler.new)
        @addr    = addr
        @handler = handler
      end

      def ==(other)
        addr == other.addr
      end

      def join
        thread.join
      end

      def start
        @thread = Thread.new { run_loop }
        wait_till_started
        self
      end

      def stop
        thread.exit.join
      end

      private

      attr_reader :handler, :thread

      def handle(input, addr:)
        handler.handle Message.parse(input), addr: addr
      rescue Message::UnknownType
        nil
      end
    end
  end
end
