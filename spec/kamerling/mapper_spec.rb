require_relative '../spec_helper'

module Kamerling describe Mapper do
  describe '.to_h' do
    it 'returns the proper Hash representation of a Client' do
      client = Client.new addr: Addr['127.0.0.1', 1979, :TCP], busy: true
      Mapper.to_h(client).must_equal busy: true, host: '127.0.0.1',
                                     port: 1979, prot: 'TCP', uuid: client.uuid
    end

    it 'returns the proper Hash representation of a Tag' do
      project = Project.new name: 'project'
      task    = Task.new data: 'data', done: true, project: project
      Mapper.to_h(task).must_equal data: 'data', done: true,
                                   project_uuid: project.uuid, uuid: task.uuid
    end
  end
end end
