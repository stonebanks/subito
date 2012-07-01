$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock/test_unit'
require 'subito/searcher'
require 'fakeweb'

include Subito

class TestSearcher < Test::Unit::TestCase
  def setup
    @connector = Searcher.new
    flexmock(Verbose).new_instances(:instance).should_receive(:msg).with_any_args.and_return(nil)
  end
  def test_must_raise_an_error_if_connection_cant_be_made
    FakeWeb.register_uri(:get, %r(http://.*), 
                         :body => "Nothing to be found 'round here",
                         :status => ["404", "Not Found"])
    assert_raises WebSiteNotReachableError do
      @connector.send(:connect)
    end
  end

  def test_must_return_a_mechanize_page
    FakeWeb.register_uri(:get, %r(http://.*),
                          :body =>  "<form><div><b>0 results found</b></div></form>",
                          :content_type => "text/html")
    assert_instance_of Mechanize::Page, @connector.send(:connect)
  end



  def test_must_be_able_to_find_the_right_tv_show_page 
    FakeWeb.register_uri(:get, 
                         "http://www.addic7ed.com/re_episode.php?ep=1234-01x03",
                         :body =>  "Hello World!", :content_type => "text/html")
    assert_equal "Hello World!", @connector.search(id: "1234", season:"01", episode:"03").body
  end

  def test_must_not_try_to_connect_if_at_least_one_value_of_args_is_nil
    FakeWeb.register_uri(:get, 
                         "http://www.addic7ed.com/re_episode.php?ep=1234-01x03",
                         :body =>  "Hello World!", :content_type => "text/html")
    assert_nil @connector.search(id:"12")
  end
end
