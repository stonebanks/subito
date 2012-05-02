$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock/test_unit'
require 'subito/sub_site_crawler'
require 'fakeweb'

include Subito

class TestSubtitlesUrlsGetter < Test::Unit::TestCase

  def setup
    @subs = SubtitlesUrlsGetter.new
    PAGE  = <<-EOF
     
    EOF
  end
  
  def test_must_return_an_hash_formatted_with_version_language_and_urls
    assert_equal(
                 {"fqm" =>
                   { "english" => '/original/1/1122'
                     "french"  => '/original/3/21'
                   }
                 }, @subs.run)
  end

  
end
