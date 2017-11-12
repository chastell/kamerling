require_relative '../test_helper'
require_relative '../../lib/kamerling/project'

module Kamerling
  describe Project do
    describe '#to_h' do
      it 'returns a Hash representation of the Project' do
        gimps = Project.new(name: 'GIMPS')
        _(gimps.to_h).must_equal id: any(String), name: 'GIMPS'
      end
    end
  end
end
