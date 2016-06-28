# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/registration'

module Kamerling
  describe Registration do
    describe '#registered_at' do
      it 'defaults to the current time' do
        registered_at = Registration.new.registered_at
        assert registered_at.between?(Time.now - 1, Time.now + 1)
      end

      it 'defaults to the time of Registration’s creation' do
        registered_at = Registration.new.registered_at
        _(registered_at).wont_equal Registration.new.registered_at
      end

      it 'is in UTC' do
        _(Registration.new.registered_at.zone).must_equal 'UTC'
      end
    end

    describe '#to_h' do
      it 'returns a Hash representation of the Registration' do
        addr    = Addr['127.0.0.1', 1979, :UDP]
        client  = Client.new(id: 'client id')
        project = Project.new(id: 'project id')
        reg     = Registration.new(addr: addr, client: client, project: project)
        iso8601 = ->(time) { time[/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/] }
        _(reg.to_h).must_equal client_id: 'client id', host: '127.0.0.1',
                               id: any(String), port: 1979,
                               project_id: 'project id', prot: 'UDP',
                               registered_at: matches(&iso8601)
      end
    end
  end
end
