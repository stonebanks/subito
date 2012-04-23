$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'sub_site_crawler'
require 'fakeweb'
require 'nokogiri'

include Nokogiri
include Subito
class TestSubSiteCrawler< Test::Unit::TestCase
ADDICTED = "http://www.addic7ed.com"
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
