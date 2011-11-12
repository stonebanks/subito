$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'fakeweb'
require 'file_downloader'


class DownloadManagerTest < Test::Unit::TestCase

  def setup
    @file_dl = FileDownloader.new("http://www.example.com/toto.srt")
  end
  #est ce que j'ai bien un fichier en sortie(?)
  # est-ce que le content type est bien un srt(?) pb:dans le cas ou on dl un zip comment ca se passe?
  def test_should_return_true_if_is_srt
    FakeWeb.register_uri(:get,
                         %r|http://example\.com/|,
                         :body => "Hello World!",
                         :content_type => "text/srt")
    assert @file_dl.is_srt?
  end
  # def test_should_raise_an_exception_if_content_type_is_not_text_srt
  #   FakeWeb.register_uri(:get, %r|http://example\.com/|, :body => "Hello World!", :content_type => "text/plain")
    
  # end
    
end

