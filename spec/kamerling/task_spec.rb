require_relative '../spec_helper'

module Kamerling describe Task do
  describe '.from_h' do
    it 'backtranslates a project_uuid to project' do
      Repos << project = Project[name: 'project name', uuid: '16B project UUID']
      Task.from_h(input: 'input', project_uuid: '16B project UUID',
        uuid: '16B task    UUID').project.must_equal project
    end
  end

  describe '#to_h' do
    it 'represents project as its UUID' do
      project = Project[name: 'project name', uuid: '16B project UUID']
      Task[input: 'task input', project: project, uuid: '16B task    UUID']
        .to_h[:project_uuid].must_equal '16B project UUID'
    end
  end
end end
