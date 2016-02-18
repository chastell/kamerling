# frozen_string_literal: true

require 'socket'

module Kamerling
  module NetDispatcher
    module_function

    def dispatch(message, addr:)
      bytes = message.to_s
      case addr.prot
      when :TCP then TCPSocket.open(*addr) { |socket| socket << bytes }
      when :UDP then UDPSocket.new.send bytes, 0, *addr
      end
    end
  end
end
