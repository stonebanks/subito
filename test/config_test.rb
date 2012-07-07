$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/config'


class TestSConfig < Test::Unit::TestCase
  include Subito
  [:ressources_subsite_name, 
   :ressources_searching_url,
   :xpaths_sections,
   :language_fr,
   :language_h,
   :language_cs,
   :database_data_xpath].each do |method|
    TestSConfig.class_eval  <<-EOS
        def test_method_#{method}_is_defined?
          assert(SConfig.instance.respond_to? :#{method}, "method undefined")
        end
        EOS
   end

    def test_method_otoguhtguthgut_is_undefined
      assert_equal false, SConfig.instance.respond_to?(:otoguhtguthgut)
    end

    def test_method_must_return_string
      assert_equal String, SConfig.instance.database_data_xpath.class
    end
end

