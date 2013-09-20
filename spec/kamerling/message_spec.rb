require_relative '../spec_helper'
require_relative '../message_behaviour'

module Kamerling describe Message do
  include MessageBehaviour

  let(:mess) do
    Message.new "MESS\0\0\0\0\0\0\0\0\0\0\0\0" +
      '16B client  UUID16B project UUID16B task    UUIDsome payload'
  end
end end
