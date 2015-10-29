require_relative '../test_helper'
require_relative '../../lib/kamerling/result'

module Kamerling
  describe Result do
    describe '#new_to_h' do
      it 'returns a Hash representation of the Registration' do
        addr    = Addr['127.0.0.1', 1979, :UDP]
        client  = Client.new(uuid: 'client UUID')
        task    = Task.new(uuid: 'task UUID')
        result  = Result.new(addr: addr, client: client, data: 'data',
                             task: task)
        iso8601 = ->(time) { time[/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/] }
        _(result.new_to_h).must_equal client_uuid: 'client UUID', data: 'data',
                                      host: '127.0.0.1', port: 1979,
                                      task_uuid: 'task UUID', prot: 'UDP',
                                      received_at: matches(&iso8601),
                                      uuid: any(String)
      end
    end

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
  end
end
