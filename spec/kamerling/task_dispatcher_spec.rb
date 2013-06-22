require_relative '../spec_helper'

module Kamerling describe TaskDispatcher do
  describe '#dispatch' do
    it 'dispatches tasks to free TCP clients' do
      client  = fake :client, addr: Addr['127.0.0.1', 1980, 'TCP'], busy: false,
        uuid: UUID['16B client  UUID']
      project = fake :project, uuid: UUID['16B project UUID']
      task    = fake :task, input: 'task input', project: project,
        uuid: UUID['16B task    UUID']

      repos = fake :repos, as: :class, projects: [project]
      stub(repos).free_clients_for(project) { [client] }
      stub(repos).next_task_for(project) { task }

      message = nil
      thread  = Thread.new do
        socket  = TCPServer.new('127.0.0.1', 1980).accept
        message = socket.read
        socket.close
      end
      sleep 0.01
      TaskDispatcher.new.dispatch repos: repos
      thread.join

      message.must_equal "DATA\0\0\0\0\0\0\0\0\0\0\0\0" +
        '16B client  UUID16B project UUID16B task    UUIDtask input'
      client.must_have_received :busy=, true
      repos.must_have_received :<<, [client]
    end
  end
end end
