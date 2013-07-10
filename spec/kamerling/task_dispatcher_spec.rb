require_relative '../spec_helper'

module Kamerling describe TaskDispatcher do
  def server_and_thread_for type
    server = case type
             when :TCP then TCPServer.open 0
             when :UDP then UDPSocket.new.tap { |s| s.bind '127.0.0.1', 0 }
             end
    thread = case type
             when :TCP then Thread.new { server.accept.read }
             when :UDP then Thread.new { server.recvfrom(2**16).first }
             end
    [server, thread]
  end

  describe '#dispatch' do
    [:TCP, :UDP].each do |type|
      it "dispatches tasks to free #{type} clients" do
        server, thread = server_and_thread_for type

        addr    = Addr[server.addr[3], server.addr[1], type]
        client  = fake :client, addr: addr, uuid: UUID['16B client  UUID']
        project = fake :project, uuid: UUID['16B project UUID']
        task    = fake :task, input: 'input', uuid: UUID['16B task    UUID']
        repos   = fake :repos, as: :class, projects: [project]
        stub(repos).next_task_for(project) { task }
        stub(repos).free_clients_for(project) { [client] }

        TaskDispatcher.new(repos: repos).dispatch

        thread.value.must_equal "DATA\0\0\0\0\0\0\0\0\0\0\0\0" +
          '16B client  UUID16B project UUID16B task    UUIDinput'
        client.must_have_received :busy=, true
        repos.must_have_received :<<, [client]
      end
    end
  end
end end
