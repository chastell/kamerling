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
  end
end
