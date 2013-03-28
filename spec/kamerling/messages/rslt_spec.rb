require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe RSLT do
  let(:mess) { RSLT.new 'RSLT' + "\0" * 12 + cuuid + puuid + tuuid + data }
  include MessageBehaviour
end end end
