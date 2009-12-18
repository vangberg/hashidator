require 'test/helper'

class TestHashidator < Test::Unit::TestCase
  def h(schema, input)
    Hashidator.validate(schema, input)
  end

  def test_validate_integer
    assert_true h({:age => Integer}, {:age => 20})
  end

  def test_invalidate_integer
    assert_false h({:age => Integer}, {:age => "twenty"})
  end

  def test_validate_string
    assert_true h({:name => String}, {:name => "Harry"})
  end

  def test_invalidate_string
    assert_false h({:name => String}, {:name => 44667})
  end

  def test_validate_in_range
    assert_true h({:age => (10..20)}, {:age => 10})
    assert_true h({:age => (10..20)}, {:age => 15})
    assert_true h({:age => (10..20)}, {:age => 20})
  end

  def test_invalidate_in_range
    assert_false h({:age => (10..20)}, {:age => 9})
    assert_false h({:age => (10..20)}, {:age => 21})
  end

  def test_validate_array_members
    assert_true h({:children => [String]}, {:children => ["Sue", "Mike"]})
  end

  def test_invalidate_array_members
    assert_false h({:children => [String]}, {:children => ["Sue", 1234]})
  end

  def test_validate_boolean
    assert_true h({:admin => Boolean}, {:admin => true})
    assert_true h({:admin => Boolean}, {:admin => true})
  end

  def test_invalidate_boolean
    assert_false h({:admin => Boolean}, {:admin => 1234})
  end

  def test_validate_respond_to
    assert_true h({:name => :to_s}, {:name => "Harry"})
  end

  def test_invalidate_respond_to
    assert_false h({:name => :non_existing_method}, {:name => "Harry"})
  end

  def test_validate_array_members_respond_to
    assert_true h(
      {:names => [:to_s]},
      {:names => ["Harry", "Damone"]}
    )
  end

  def test_invalidate_array_members_respond_to
    assert_false h(
      {:name => [:non_existing_method]},
      {:name => ["Harry", "Damone"]}
    )
  end

  def test_validate_nested
    schema = {:name => {:first => String, :last => String}}
    assert_true h(schema, {:name => {:first => "Mike", :last => "Damone"}})
  end

  def test_invalidate_nested
    schema = {:name => {:first => String, :last => String}}
    assert_false h(schema, {:name => {:first => "Mike", :last => 1234}})
  end
end