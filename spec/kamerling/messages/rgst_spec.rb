require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe RGST do
  let(:mess) { RGST.new "RGST\0\0\0\0\0\0\0\0\0\0\0\0" +
    '16B client  UUID16B project UUID16B task    UUIDsome payload' }
  include MessageBehaviour
end end end
