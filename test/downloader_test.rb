$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'fakeweb'
require 'subito/downloader'
require 'flexmock/test_unit'


include Subito
class DownloadManagerTest < Test::Unit::TestCase

  def setup
    hash_urls =  {  
      "x264-asap" => { 
        "english" => ['/original/1122/0'],
        "french"  => ['/original/21/3'] },
      "lol" => { 
        "english" => ['/original/1223/0'] }
    }

    @tv_show_feature = flexmock("TVShowFeature")
    @downloader = Downloader.new(hash_urls, @tv_show_feature)
    flexmock(SConfig).new_instances(:instance).should_receive(:ressources_subsite_name).and_return("http://toto.com")
  end
  def test_should_retrieve_url_for_the_team_and_language
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
  
  def test_should_retrieve_url_if_team_contains_the_given_character
    @tv_show_feature.should_receive(:team =>"asap")
    assert_equal('http://toto.com/original/1122/0', 
                 @downloader.retrieve_url_for("english"))
  end
end

