# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/result'

module Kamerling
  describe Result do
    describe '#received_at' do
      it 'defaults to the current time' do
        assert Result.new.received_at.between?(Time.now - 1, Time.now + 1)
      end

      it 'defaults to the time of Result’s creation' do
        _(Result.new.received_at).wont_equal Result.new.received_at
      end

      it 'is in UTC' do
        _(Result.new.received_at.zone).must_equal 'UTC'
      end
    end

    describe '#to_h' do
      it 'returns a Hash representation of the Result' do
        addr    = Addr['127.0.0.1', 1979, :UDP]
        client  = Client.new(id: 'client id')
        task    = Task.new(id: 'task id')
        result  = Result.new(addr: addr, client: client, data: 'data',
                             task: task)
        iso8601 = ->(time) { time[/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/] }
        _(result.to_h).must_equal client_id: 'client id', data: 'data',
                                  host: '127.0.0.1', id: any(String),
                                  port: 1979, task_id: 'task id', prot: 'UDP',
                                  received_at: matches(&iso8601)
      end
    end
  end
end
