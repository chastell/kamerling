require_relative '../spec_helper'

module Kamerling describe Task do
  describe '.from_h' do
    it 'backtranslates a project_uuid to project' do
      project = fake :project
      repos   = { Project => { project.uuid => project } }
      hash    = { input: 'input', project_uuid: project.uuid, uuid: UUID.new }
      Task.from_h(hash, repos).project.must_equal project
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
