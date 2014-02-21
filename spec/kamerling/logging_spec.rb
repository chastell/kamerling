require_relative '../spec_helper'

module Kamerling describe Logging do
  describe '.new' do
    it 'logs TCP server starts' do
      stream = StringIO.new
      Logging.new logger: Logger.new(stream)
      server = Server::TCP.new addr: Addr['localhost', 1981, :TCP]
      server.start.stop
      stream.rewind
      stream.read.must_include 'start localhost:1981 (TCP)'
    end
  end
end end
