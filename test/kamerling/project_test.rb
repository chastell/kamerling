# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/project'

module Kamerling
  describe Project do
    describe '#new_to_h' do
      it 'returns a Hash representation of the Project' do
        gimps = Project.new(name: 'GIMPS')
        _(gimps.new_to_h).must_equal name: 'GIMPS', uuid: any(String)
      end
    end
  end
end
