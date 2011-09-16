$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'exception_raiser'

include ExceptionRaiser
class TestExceptionRaiser < Test::Unit::TestCase
  def setup
    File.open('foo', 'wb'){}
  end
  def test_should_raise_an_exception_if_file_doesnt_exist
    assert_raises UnknownFileError do 
      raise_if_unknown_file('bar')
    end
  end
  
  def test_should_not_raise_exceptin_if_file_exists
    assert_nothing_raised do 
      raise_if_unknown_file 'foo'
    end
  end

  def test_should_raise_an_exception_if_string_empty
    assert_raises EmptyStringError do 
      raise_if_empty_string('')
    end
  end

  def test_should_not_raise_exception_if_string_empty
    assert_nothing_raised do 
      raise_if_empty_string 'foo'
    end
  end

  def test_should_raise_an_exception_if_type_is_bad
    assert_raises BadTypeError do 
      raise_if_bad_type(Hash.new,String)
    end
  end

  def test_should_not_raise_exception_if_type_is_good
    assert_nothing_raised do 
      raise_if_bad_type '',String
    end
  end

  def test_should_raise_an_exception_if_nomethod
    assert_raises ExceptionRaiser::NoMethodError do
      raise_if_nomethod String.new, :titi
    end
  end
  def test_should_not_raise_an_exception_if_nomethod
    assert_nothing_raised do 
      raise_if_nomethod '',:empty?
    end
  end

  def test_should_raise_a_runtime_error_when_a_custom_exception_is_encountered
    assert_raise ExceptionRaiser::RuntimeError do
      raise_custom('foo',msg: "file foo already exists"){|k| File.exists? k}
    end
  end
 def test_should_raise_a_badtype_error_when_a_custom_exception_is_encountered
    assert_raise ExceptionRaiser::BadTypeError do
      raise_custom('foo',excpt_type: BadTypeError, msg: "file foo already exists"){|k| !k.kind_of? Hash }
    end
  end
  def test_should_not_raise_any_runtimeerror
    assert_nothing_raised do 
      raise_custom([1,2,3,4,7], msg: "One of the number is greater than 6")do 
        |k| k.all? {|nb| nb < 6}
      end
    end
  end
  
  def teardown
    require 'fileutils'
    FileUtils.rm_f 'foo'
  end
end
