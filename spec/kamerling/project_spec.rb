require_relative '../spec_helper'

module Kamerling describe Project do
  describe '.from_h' do
    it 'deserialises a project from a hash' do
      hash = { name: name = 'project name', uuid: uuid = UUID.new }
      Project.from_h(hash).must_equal Project[name: name, uuid: uuid]
    end
  end
end end
