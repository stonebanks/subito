$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'my_utils'


include MyUtils

class TestCreateRegExp < Test::Unit::TestCase
  
  def test_should_return_a_regexp_if_an_array_of_string_was_passed_as_arg
    assert create_regexp(['foo', 'bar']).kind_of? Regexp
  end

  def test_should_return_an_exception_if_args_is_non_stringarray
    assert_raise BadTypeError do 
      create_regexp({})
    end
  end
  
  def test_should_return_nil_if_array_or_string_is_empty
    assert create_regexp([]).kind_of? NilClass
  end

  def test_should_build_the_wanted_regexp
    assert_equal %r{foo|bar|and|co}, create_regexp(['foo', 'bar', 'and', 'co'])
  end

  def test_should_build_the_wanted_regexp_if_block_is_given
    assert_equal %r{(foo|bar|and|co).*(\d)}, create_regexp(['foo', 'bar', 'and', 'co']){|k| "(#{k}).*(\\d)"}
  end

end
