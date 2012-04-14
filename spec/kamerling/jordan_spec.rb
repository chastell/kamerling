# encoding: UTF-8

require_relative '../spec_helper'

module Kamerling describe Jordan do
  let(:jordan) { Jordan.new }

  def with_jordan_running
    EM.run do
      yield
      EM.stop
    end
  end

  describe '.new' do
    it 'starts the server on the given host and port' do
      with_jordan_running do
        TCPSocket.new(jordan.host, jordan.port).close
      end
    end
  end

  describe '#host' do
    it 'returns the server’s host (127.0.0.1 by default)' do
      with_jordan_running do
        jordan.host.must_equal '127.0.0.1'
      end
    end
  end

  describe '#port' do
    it 'returns the server’s port (random available by default)' do
      with_jordan_running do
        (1024..65535).must_include jordan.port
      end
    end
  end
end end
