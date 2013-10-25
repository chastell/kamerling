require_relative '../spec_helper'

module Kamerling describe NetDispatcher do
  let(:tcp_server) { TCPServer.open 0                                }
  let(:udp_server) { UDPSocket.new.tap { |s| s.bind '127.0.0.1', 0 } }
  let(:tcp_thread) { Thread.new { tcp_server.accept.read }           }
  let(:udp_thread) { Thread.new { udp_server.recvfrom(2**16).first } }

  describe '#dispatch' do
    [:TCP, :UDP].each do |type|
      it "dispatches messages to #{type} clients" do
        server = send "#{type.downcase}_server"
        thread = send "#{type.downcase}_thread"
        addr   = Addr[server.addr[3], server.addr[1], type]
        NetDispatcher.new(addr).dispatch 'foo'
        thread.value.must_equal 'foo'
      end
    end
  end
end end
