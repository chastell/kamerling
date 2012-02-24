require_relative '../spec_helper'

module Kamerling describe Jordan do
  include EM::MiniTest::Spec

  describe '#start' do
    it 'starts the server on the given host and port' do
      host, port = '127.0.0.1', rand(49152..65535)
      Jordan.new(:host => host, :port => port).start
      TCPSocket.new(host, port).close
    end
  end
end end
