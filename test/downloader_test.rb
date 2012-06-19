$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'fakeweb'
require 'subito/downloader'
require 'flexmock/test_unit'


include Subito
class DownloadManagerTest < Test::Unit::TestCase

  def setup
    hash_urls =  {  "fqm" => { "english" => '/original/1122/0',
                              "french"  => '/original/21/3' },
                    "lol" => { "english" => '/original/1223/0' }}
    @tv_show_feature = flexmock("TVShowFeature")
    @downloader = Downloader.new(hash_urls, @tv_show_feature)
    flexmock(SConfig).new_instances(:instance).should_receive(:ressources_subsite_name).and_return("http://toto.com")
  end
  def test_should_retrieve_url_for_the_right_team_and_language
    @tv_show_feature.should_receive(:team =>"lol")
    assert_equal('http://toto.com/original/1223/0', 
                 @downloader.retrieve_url_for("english"))
  end

  def test_should_return_nil_if_team_does_not_exist
    @tv_show_feature.should_receive(:team =>"foo")
    assert_nil(@downloader.retrieve_url_for("english"))
  end
  
  def test_should_return_nil_if_language_does_not_exist
    @tv_show_feature.should_receive(:team =>"lol")
    assert_nil(@downloader.retrieve_url_for("foo"))
  end

  # def test_download_should_succeed
  #   FakeWeb.register_uri(:get,
  #                        %r|http://example\.com/|,
  #                        :body => "Hello World!",
  #                        :content_type => "text/srt")
  #   @tv_show_feature.should_receive(:raw_name =>"foobar.s01e02.hdtv-lol.avi")
  #   assert_eql("foobar.s01e02.hdtv-lol.srt",  @downloader.download "http://example.com")
  # end
  # def setup
  #   @file_dl = FileDownloader.new("http://www.example.com/toto.srt")
  # end
  # #est ce que j'ai bien un fichier en sortie(?)
  # # est-ce que le content type est bien un srt(?) pb:dans le cas ou on dl un zip comment ca se passe?
  # def test_should_return_true_if_is_srt
  #   FakeWeb.register_uri(:get,
  #                        %r|http://example\.com/|,
  #                        :body => "Hello World!",
  #                        :content_type => "text/srt")
  #   assert @file_dl.is_srt?
  # end
  # # def test_should_raise_an_exception_if_content_type_is_not_text_srt
  # #   FakeWeb.register_uri(:get, %r|http://example\.com/|, :body => "Hello World!", :content_type => "text/plain")
    
  # # end
    
end

