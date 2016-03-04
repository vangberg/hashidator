require 'minitest/autorun'
require 'hashidator'

class Minitest::Test
  def assert_true(subject)
    assert_equal true, subject
  end

  def assert_false(subject)
    assert_equal false, subject
  end
end
