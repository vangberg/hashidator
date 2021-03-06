require 'helper'

class TestHashidator < Minitest::Test
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

  def test_validate_empty_array_members
    assert_true h({:children => [String]}, {:children => []})
  end

  def test_invalidate_array_members
    assert_false h({:children => [String]}, {:children => ["Sue", 1234]})
  end

  def test_invalidate_array_members_with_non_array_values
    assert_false h({:ary => [String]}, {:ary => nil})
    assert_false h({:ary => [String]}, {:ary => :not_an_array})
    assert_false h({:ary => [String]}, {:ary => {:i_am => "a hash"}})
  end

  def test_validate_boolean
    assert_true h({:admin => Boolean}, {:admin => true})
  end

  def test_invalidate_boolean
    assert_false h({:admin => Boolean}, {:admin => 1234})
  end

  def test_validate_regexp
    assert_true h({:uri => /^http:/}, {:uri => "http://example.com"})
  end

  def test_invalidate_regexp
    assert_false h({:uri => /^http:/}, {:uri => "john coltrane"})
    assert_false h({:uri => /^http:/}, {:uri => nil})
    assert_false h({:uri => /^http:/}, {:uri => :symbol})
  end

  def test_validate_exact_values
    assert_true h({:result => "ok"}, {:result => "ok"})
    assert_true h({:bool => true}, {:bool => true})
  end

  def test_invalidate_exact_values
    assert_false h({:result => "ok"}, {:result => "error"})
    assert_false h({:result => "ok"}, {:result => nil})
    assert_false h({:bool => false}, {:bool => true})
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

  def test_validate_array_members_range
    assert_true h(
      {:names => [(1..9)]},
      {:names => [1, 9]}
    )
  end

  def test_validate_proc_with_boolean_result
    assert_true h(
      {:methods => proc {|v| v.all? {|e| e.is_a?(String) || e.is_a?(Symbol) } }},
      {:methods => ["to_s", :to_h]}
    )
  end

  def test_invalidate_proc_with_boolean_result
    assert_false h(
      {:methods => proc {|v| v.all? {|e| e.is_a?(String) || e.is_a?(Symbol) } }},
      {:methods => ["to_s", 123]}
    )
  end

  def test_validate_proc_with_cascaded_result
    schema = {:methods => proc {|v| v.first.is_a?(Integer) ? [Integer] : [String] } }
    assert_true h(schema, {:methods => [1, 2]})
    assert_true h(schema, {:methods => ["Harry", "Damone"]})
  end

  def test_invalidate_proc_with_cascaded_result
    schema = {:methods => proc {|v| v.first.is_a?(Integer) ? [Integer] : [String] } }
    assert_false h(schema, {:methods => [1, "Damone"]})
    assert_false h(schema, {:methods => ["Harry", 2]})
  end

  def test_validation_with_equality
    optional = Class.new do
      def initialize(schema)
        @schema = schema
      end

      def ===(other)
        other.nil? || @schema
      end
    end

    schema = {:phone => optional.new(String)}
    assert_true h(schema, {:phone => "+49 2305 4711"})
    assert_true h(schema, {:phone => nil})
    assert_true h(schema, {})
    assert_false h(schema, {:phone => false})
    assert_false h(schema, {:phone => 1234567})
  end

  def test_validate_nested
    schema = {:name => {:first => String, :last => String}}
    assert_true h(schema, {:name => {:first => "Mike", :last => "Damone"}})
  end

  def test_invalidate_nested
    schema = {:name => {:first => String, :last => String}}
    assert_false h(schema, {:name => {:first => "Mike", :last => 1234}})
  end

  def test_validate_deep_nested
    assert_true h(
      {:people => [{ :name => :to_s, :age => (18..40)}]},
      {:people => [{ :name => "Ann", :age => 19 }, { :name => "Bob", :age => 23 }]}
    )
  end

  def test_invalidate_deep_nested
    assert_false h(
      {:people => [{ :name => :to_s, :age => (18..40)}]},
      {:people => [{ :name => "Ann", :age => 15 }, { :name => "Bob", :age => 23 }]}
    )
  end

  def test_deep_nested_validation_uses_subclass
    h = Class.new(Hashidator) do
      def validate(input)
        throw :halt, "#{input[:value]} HAMMERZEIT" if input[:value] == 'STOP'
        super
      end
    end

    caught = catch(:halt) do
      h.validate(
        {:deep => { :value => String}},
        {:deep => { :value => 'STOP'}})
    end
    assert_equal "STOP HAMMERZEIT", caught
  end

  def test_invalidate_for_nil_input
    schema = {:user => { :name => String }}
    assert_false h(schema, nil)
    assert_false h(schema, {})
    assert_false h(schema, {:user => nil})
  end
end
