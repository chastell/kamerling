require_relative '../spec_helper'

module Kamerling describe Task do
  describe '.new' do
    it 'can be instantiated with project_uuid' do
      Repos << project = Project[name: 'project name', uuid: '16B project UUID']
      task = Task[input: 'input', project_uuid: '16B project UUID',
        uuid: '16B task    UUID']
      task.project.must_equal project
    end
  end

  describe '#to_h' do
    it 'represents project as its UUID' do
      project = Project[name: 'project name', uuid: '16B project UUID']
      Task[input: 'task input', project: project, uuid: '16B task    UUID'].to_h
        .must_equal({ input: 'task input', project_uuid: '16B project UUID',
          uuid: '16B task    UUID' })
    end
  end
end end
