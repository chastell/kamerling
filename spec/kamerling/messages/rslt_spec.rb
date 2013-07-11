require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe RSLT do
  let(:mess) { RSLT.new "RSLT\0\0\0\0\0\0\0\0\0\0\0\0" +
    '16B client  UUID16B project UUID16B task    UUIDsome payload' }
  include MessageBehaviour
end end end
