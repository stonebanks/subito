$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/config'


class TestConfig < Test::Unit::TestCase
  include Subito

  def test_method_are_defined
    assert [:ressources_subsite_name, 
            :xpaths_sections,
            :language_fr].all? do |a| Config.instance.respond_to? a end
  end

end
