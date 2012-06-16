$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/yml_database'

include Subito

class TestYmlDatabase < Test::Unit::TestCase
  def setup
    @db = YamlDatabase.instance
  end
  
  def test_method_get_all_shows_similar_to_a_string_must_return_an_array
    @db.hash = {
      "fubar"=>12, 
      "fobar"=>15,
      "fooobar"=>19,
      "toto"=>1 }
    assert_equal( 
                 {"fubar"=>12, 
                   "fobar"=>15,
                   "fooobar"=>19}, 
                 @db.get_all_shows_similar_to("foobar", 0.8))
  end
  
end
