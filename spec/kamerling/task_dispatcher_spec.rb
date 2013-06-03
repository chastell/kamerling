require_relative '../spec_helper'

module Kamerling describe TaskDispatcher do
  describe '#dispatch' do
    it 'dispatches tasks to free clients' do
      endpoint = Server.new handler: handler = fake(:handler)
      project  = fake :project, uuid: UUID['16B project UUID']
      task     = fake :task, input: 'task input', project: project,
        uuid: UUID['16B task    UUID']
      client   = fake :client, addr: endpoint.addr, busy: false,
        uuid: UUID['16B client  UUID']
      repos = fake :repos, as: :class, projects: [project]
      stub(repos).free_clients_for(project) { [client] }
      stub(repos).next_task_for(project) { task }
      TCPSocket.open(*endpoint.addr) do |socket|
        TaskDispatcher.new.dispatch repos: repos
      end
      sleep 0.01
      client.must_have_received :busy=, true
      repos.must_have_received :<<, [client]
      handler.must_have_received :handle, ["DATA\0\0\0\0\0\0\0\0\0\0\0\0" +
        '16B client  UUID16B project UUID16B task    UUIDtask input', anything]
    end
  end
end end
