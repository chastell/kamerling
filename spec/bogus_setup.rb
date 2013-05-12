require 'bogus'

Bogus.configure { |config| config.search_modules << Kamerling }

module MiniTest::Assertions
  def assert_received subject, method, args, message = nil
    matcher = Bogus.have_received.__send__ method, *args
    result  = matcher.matches? subject
    message ||= matcher.failure_message_for_should
    assert result, message
  end

  def refute_received subject, method, args, message = nil
    matcher = Bogus.have_received.__send__ method, *args
    result  = matcher.matches? subject
    message ||= matcher.failure_message_for_should_not
    refute result, message
  end
end

module MiniTest::Expectations
  infect_an_assertion :assert_received, :must_have_received, true
  infect_an_assertion :refute_received, :wont_have_received, true
end

class MiniTest::Spec
  include Bogus::MockingDSL
end
