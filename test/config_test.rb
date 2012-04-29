$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/config'


class TestConfig < Test::Unit::TestCase
  include Subito

  def test_subsite_name_method_is_defined
    assert Config.instance.respond_to? :subsite_name
  end

  def test_method_searching_url_method_is_defined
    assert Config.instance.respond_to? :searching_url
  end
end
