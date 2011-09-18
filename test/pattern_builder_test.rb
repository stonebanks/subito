$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'my_utils'

include MyUtils

class TestPatternBuilder < Test::Unit::TestCase
  
  def test_shall_return_the_good_pattern_with_an_array_as_input
    assert_equal "{foo,bar,toto,printf}", build_pattern(%w(foo bar toto printf))
  end

  def test_shall_raise_an_exception_if_input_is_not_exclusevely_a_string_array
    assert_raises BadTypeError  do build_pattern(['h','u',2])end
  end
end
