require_relative '../spec_helper'

module Kamerling describe Task do
  describe '#done' do
    it 'defaults to false' do
      Task[input: 'input', project: fake(:project)].done.must_equal false
    end
  end
end end
