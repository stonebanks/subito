$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock/test_unit'
require 'subito/sub_site_crawler'
require 'fakeweb'

include Subito

class TestSubtitlesUrlsGetter < Test::Unit::TestCase
  def test_must_return_an_hash
    
  end

  
end
