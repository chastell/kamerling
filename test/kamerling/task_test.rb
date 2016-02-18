# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/task'

module Kamerling
  describe Task do
    describe '#done' do
      it 'defaults to false' do
        refute Task.new(data: 'data', project: Project.new).done
      end
    end

    describe '#new_to_h' do
      it 'returns a Hash representation of the Task' do
        project = Project.new(uuid: 'project UUID')
        task    = Task.new(data: 'data', done: true, project: project)
        _(task.new_to_h).must_equal data: 'data', done: true,
                                    project_uuid: 'project UUID',
                                    uuid: any(String)
      end
    end
  end
end
