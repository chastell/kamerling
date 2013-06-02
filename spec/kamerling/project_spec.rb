require_relative '../spec_helper'

module Kamerling describe Project do
  describe '.from_h' do
    it 'deserialises a project from a hash' do
      hash = { name: 'project name', uuid: uuid = UUID.new }
      Project.from_h(hash).must_equal Project[name: 'project name', uuid: uuid]
    end
  end

  describe '.new' do
    it 'gives the project a random UUID if not provided' do
      p1 = Project[name: 'a']
      p2 = Project[name: 'b']
      p1.uuid.wont_equal p2.uuid
    end
  end
end end
