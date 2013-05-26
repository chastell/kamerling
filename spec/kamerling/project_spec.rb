require_relative '../spec_helper'

module Kamerling describe Project do
  describe '.from_h' do
    it 'deserialises a project from a hash' do
      Project.from_h(name: 'project name', uuid: '16B project UUID')
        .must_equal Project[name: 'project name', uuid: '16B project UUID']
    end
  end
end end
