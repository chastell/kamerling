require_relative '../spec_helper'

module Kamerling describe Task do
  before { Repos.db = Sequel.sqlite }

  describe '.from_h' do
    it 'backtranslates a project_uuid to project' do
      Repos << project = Project[name: 'project name', uuid: puuid = UUID.new]
      hash = { input: 'input', project_uuid: puuid, uuid: UUID.new }
      Task.from_h(hash).project.must_equal project
    end
  end

  describe '#to_h' do
    it 'represents project as its UUID' do
      project = Project[name: 'project name', uuid: puuid = UUID.new]
      task    = Task[input: 'task input', project: project, uuid: UUID.new]
      task.to_h[:project_uuid].must_equal puuid
    end
  end
end end
