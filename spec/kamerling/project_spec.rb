require_relative '../spec_helper'

module Kamerling describe Project do
  describe '.from_h' do
    it 'deserialises a project from a hash' do
      hash = { name: 'project name', uuid: UUID.from_bin('16B project UUID') }
      Project.from_h(hash).must_equal Project[name: 'project name',
        uuid: UUID.from_bin('16B project UUID')]
    end
  end
end end
