require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe RGST do
  let(:mess) { RGST.new 'RGST' + "\0" * 12 + cuuid + puuid + tuuid + data }
  include MessageBehaviour
end end end
