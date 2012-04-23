$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'sub_site_crawler'
require 'fakeweb'
require 'nokogiri'

include Nokogiri
include Subito



class TestSubSiteCrawler_Search < Test::Unit::TestCase
  def setup
    @crawl = SubSiteCrawler.new
#    @crawl.connect
  end


  def test_search_must_return_nil_if_theres_no_result
    FakeWeb.register_uri (:get, 
                          "http://www.addic7ed.com",
                          :body =>  "<form><div><b>0 results found</b></div></form>",
                          :content_type => "text/html")
    @crawl.connect
    assert_equal nil, @crawl.search('foobar 01x02')
  end
  

  def test_search_must_return_a_mechanize_page_link_if_results_found
    FakeWeb.register_uri (:get, 
                          "http://www.addic7ed.com",
                          :body =>  "<form>
                                       <div><b>1 results found</b></div>
                                    </form>
                                    <table>
                                     <tr><td><a debug='22' href='serie/foobar/1/2/title'>Foobar - 01x02 - Title</a></td>
                                     </tr>
                                    </table>",
                          :content_type => "text/html")
    @crawl.connect
    assert_equal Mechanize::Page::Link, @crawl.search('foobar 01x02').class
  end

  def test_search_must_return_the_right_link_if_results_found
    FakeWeb.register_uri (:get, 
                          "http://www.addic7ed.com",
                          :body =>  "<form>
                                       <div><b>1 results found</b></div>
                                    </form>
                                    <table>
                                     <tr><td><a debug='22' href='serie/foobar/1/2/title'>Foobar - 01x02 - Title</a></td>
                                     </tr>
                                     <tr><td><a debug='22' href='serie/Awesome_foobar/1/2/title'>Awesome Foobar - 01x02 - Title</a></td>
                                     </tr>
                                    </table>",
                          :content_type => "text/html")
    @crawl.connect
    assert_not_nil   @crawl.search('foobar 01x02').text[/^Foobar - 01x02/]
  end

  def teardown
  end
end


class TestSubSiteCrawler< Test::Unit::TestCase
  def setup
    @crawl= SubSiteCrawler.new
    @page = File.open('./ressource/page.html','r') do |f|
      f.read
    end
  end

  def test_connect_method_must_raise_an_exception_if_addicted_website_is_not_reachable
     FakeWeb.register_uri(:get, ADDICTED, 
                          :body => "Nothing to be found 'round here",
                          :status => ["404", "Not Found"])
    assert_raises WebSiteNotReachableError do
      @crawl.connect
    end
  end

  def test_search_method_must_raise_an_exception_if_no_result_is_found
    page = <<-EOF
    <document>
      <html>
        <body>
         <form>
          <div><b>0 results found</b></div>
         </form>
        </body>
      </html>
    </document>
    EOF
    FakeWeb.register_uri(:get, ADDICTED, :response => page)
    @crawl.connect
    assert_raises NoResultError do
      @crawl.search("foobar")
    end
  end
 
  def test_parse_method_must_get_each_subtitle_urls_in_each_language_for_the_right_versions

    page = File.open ('ressource/page.html','r') do |f|
      f.read
    end
    FakeWeb.register_uri(:get, ADDICTED, 
                         :response => page)                        
    @crawl.connect
    @crawl.search("Up.All.Night.S01E01.HDTV.XviD-LOL.avi")
    @crawl.parse



    def test_
    end
#    version => language1 => url
#            => language2 => url
  end
  
  def teardown
  end
end