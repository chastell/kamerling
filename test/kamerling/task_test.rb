require_relative '../test_helper'
require_relative '../../lib/kamerling/task'

module Kamerling
  describe Task do
    describe '#done' do
      it 'defaults to false' do
        refute Task.new(data: 'data').done
      end
    end

    describe '#to_h' do
      it 'returns a Hash representation of the Task' do
        task = Task.new(data: 'data', done: true)
        _(task.to_h).must_equal data: 'data', done: true, id: any(String)
      end
    end
  end
end
