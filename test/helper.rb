$:.unshift "lib"

require 'test/unit'
require 'contest'
require 'hashidator'

class Test::Unit::TestCase
  def assert_true(subject)
    assert_equal true, subject
  end

  def assert_false(subject)
    assert_equal false, subject
  end
end
