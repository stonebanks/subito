$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'fakeweb'


class FileDownloaderTest < Test::Unit::TestCase
  def test_should_
end
FakeWeb.register_uri(:get, %r|http://example\.com/|, :body => "Hello World!", :content_type => "text/plain")

