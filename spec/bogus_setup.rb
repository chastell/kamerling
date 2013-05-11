require 'bogus'

include Bogus::MockingDSL

Bogus.configure { |config| config.search_modules << Kamerling }

module MiniTest::Assertions
  def assert_received subject, method, args
    matcher = Bogus.have_received.__send__ method, *args
    assert matcher.matches?(subject), matcher.failure_message_for_should
  end

  def refute_received subject, method, args
    matcher = Bogus.have_received.__send__ method, *args
    refute matcher.matches?(subject), matcher.failure_message_for_should_not
  end
end

module MiniTest::Expectations
  infect_an_assertion :assert_received, :must_have_received, true
  infect_an_assertion :refute_received, :wont_have_received, true
end
