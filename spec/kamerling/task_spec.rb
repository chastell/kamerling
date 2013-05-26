require_relative '../spec_helper'

module Kamerling describe Task do
  describe '.from_h' do
    it 'backtranslates a project_uuid to project' do
      Repos << project = Project[name: 'project name', uuid: '16B project UUID']
      Task.from_h(input: 'input', project_uuid: '16B project UUID',
        uuid: '16B task    UUID').must_equal Task[input: 'input',
          project: project, uuid: '16B task    UUID']
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
