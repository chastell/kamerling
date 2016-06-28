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

    describe '#to_h' do
      it 'returns a Hash representation of the Task' do
        project = Project.new(id: 'project id')
        task    = Task.new(data: 'data', done: true, project: project)
        _(task.to_h).must_equal data: 'data', done: true, id: any(String),
                                project_id: 'project id'
      end
    end
  end
end
