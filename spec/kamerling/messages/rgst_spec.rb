require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe RGST do
  include MessageBehaviour

  let(:mess) do
    RGST.new "RGST\0\0\0\0\0\0\0\0\0\0\0\0" +
      '16B client  UUID16B project UUID16B task    UUIDsome payload'
  end
end end end
