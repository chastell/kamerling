require_relative '../spec_helper'

module Kamerling describe TaskDispatcher do
  let(:tcp_server) { TCPServer.open 0                                }
  let(:udp_server) { UDPSocket.new.tap { |s| s.bind '127.0.0.1', 0 } }
  let(:tcp_thread) { Thread.new { tcp_server.accept.read }           }
  let(:udp_thread) { Thread.new { udp_server.recvfrom(2**16).first } }

  describe '#dispatch' do
    [:TCP, :UDP].each do |type|
      it "dispatches tasks to free #{type} clients" do
        server  = send "#{type.downcase}_server"
        thread  = send "#{type.downcase}_thread"
        addr    = Addr[server.addr[3], server.addr[1], type]
        client  = fake :client, addr: addr, uuid: UUID['16B client  UUID']
        project = fake :project, uuid: UUID['16B project UUID']
        task    = fake :task, data: 'data', uuid: UUID['16B task    UUID']
        repos   = fake :repos, as: :class, projects: [project]
        stub(repos).next_task_for(project) { task }
        stub(repos).free_clients_for(project) { [client] }

        TaskDispatcher.new(repos: repos).dispatch

        thread.value.must_equal "DATA\0\0\0\0\0\0\0\0\0\0\0\0" +
          '16B client  UUID16B project UUID16B task    UUIDdata'
        client.must_have_received :busy=, true
        repos.must_have_received :<<, [client]
      end
    end
  end
end end
