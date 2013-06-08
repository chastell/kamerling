require_relative '../spec_helper'

module Kamerling describe Task do
  fakes :project

  describe '.new' do
    it 'gives the task a random UUID' do
      t1 = Task[input: 'some input', project: project]
      t2 = Task[input: 'some input', project: project]
      t1.uuid.wont_equal t2.uuid
    end
  end

  describe '#done' do
    it 'defaults to false' do
      Task[input: 'input', project: fake(:project)].done.must_equal false
    end
  end
end end
