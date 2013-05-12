require 'bogus'

Bogus.configure { |config| config.search_modules << Kamerling }

module MiniTest::Assertions
  def assert_received subject, method, args, message = nil
    with_bogus_matcher_for subject, method, args do |matcher, result|
      assert result, message || matcher.failure_message_for_should
    end
  end

  def refute_received subject, method, args, message = nil
    with_bogus_matcher subject, method, args do |matcher, result|
      refute result, message || matcher.failure_message_for_should_not
    end
  end

  private

  def with_bogus_matcher_for subject, method, args
    matcher = Bogus.have_received.__send__ method, *args
    result  = matcher.matches? subject
    yield matcher, result
  end
end

module MiniTest::Expectations
  infect_an_assertion :assert_received, :must_have_received, true
  infect_an_assertion :refute_received, :wont_have_received, true
end

class MiniTest::Spec
  include Bogus::MockingDSL
end
