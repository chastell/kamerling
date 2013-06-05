require_relative '../spec_helper'

module Kamerling describe Task do
  fakes :project

  describe '.from_h' do
    it 'backtranslates a project_uuid to project' do
      repos = { Project => { project.uuid => project } }
      hash  = { input: 'input', project_uuid: project.uuid, uuid: UUID.new }
      Task.from_h(hash, repos).project.must_equal project
    end
  end

  describe '.new' do
    it 'gives the task a random UUID' do
      t1 = Task[input: 'some input', project: project]
      t2 = Task[input: 'some input', project: project]
      t1.uuid.wont_equal t2.uuid
    end
  end

  describe '#to_h' do
    it 'represents project as its UUID' do
      task = Task[input: 'task input', project: project, uuid: UUID.new]
      task.to_h[:project_uuid].must_equal project.uuid
    end
  end
end end
