require_relative '../spec_helper'

module Kamerling describe Task do
  before { Repos.db = Sequel.sqlite }

  describe '.from_h' do
    it 'backtranslates a project_uuid to project' do
      project_uuid = UUID.from_bin '16B project UUID'
      Repos << project = Project[name: 'project name', uuid: project_uuid]
      hash = { input: 'input', project_uuid: project_uuid,
        uuid: UUID.from_bin('16B task    UUID') }
      Task.from_h(hash).project.must_equal project
    end
  end

  describe '#to_h' do
    it 'represents project as its UUID' do
      project_uuid = UUID.from_bin '16B project UUID'
      project = Project[name: 'project name', uuid: project_uuid]
      task    = Task[input: 'task input', project: project,
        uuid: UUID.from_bin('16B task    UUID')]
      task.to_h[:project_uuid].must_equal project_uuid
    end
  end
end end
