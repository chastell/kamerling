# encoding: UTF-8

require_relative '../spec_helper'

module Kamerling describe Jordan do
  let(:jordan) { Jordan.new }

  describe '.new' do
    it 'starts the server on the given host and port' do
      EM.run do
        TCPSocket.new(jordan.host, jordan.port).close
        EM.stop
      end
    end
  end

  describe '#host' do
    it 'returns the server’s host (127.0.0.1 by default)' do
      EM.run do
        jordan.host.must_equal '127.0.0.1'
        EM.stop
      end
    end
  end

  describe '#port' do
    it 'returns the server’s port (random available by default)' do
      EM.run do
        (1024..65535).must_include jordan.port
        EM.stop
      end
    end
  end
end end
