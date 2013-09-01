require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe RSLT do
  include MessageBehaviour

  let(:mess) do
    RSLT.new "RSLT\0\0\0\0\0\0\0\0\0\0\0\0" +
      '16B client  UUID16B project UUID16B task    UUIDsome payload'
  end
end end end
