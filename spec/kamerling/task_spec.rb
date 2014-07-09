require_relative '../spec_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/task'

module Kamerling describe Task do
  describe '#done' do
    it 'defaults to false' do
      Task.new(data: 'data', project: Project.new).done.must_equal false
    end
  end
end end
