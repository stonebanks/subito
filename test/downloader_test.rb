$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'fakeweb'
require 'subito/downloader'
require 'flexmock/test_unit'


include Subito
class DownloadManagerTest < Test::Unit::TestCase

  def setup
    available_subs =  {  
      "x264-asap" => { 
        "english" => ['/original/1122/0'],
        "french"  => ['/original/21/3'] },
      "lol" => { 
        "english" => ['/original/1223/0'] }
    }

    # @tv_show_feature = flexmock("TVShowFeature")
    @downloader = Downloader.new(available_subs)
    flexmock(SConfig).new_instances(:instance).should_receive(:ressources_subsite_name).and_return("http://toto.com")
  end
  def test_must_retrieve_url_for_the_given_language_and_team
  #  @tv_show_feature.should_receive(:team =>"lol")
    assert_equal('http://toto.com/original/1223/0', 
                 @downloader.retrieve_url_for(language: "english", team: "lol"))
  end

  def test_must_retrieve_url_for_the_given_language_if_team_not_complete
    assert_equal('http://toto.com/original/1122/0', 
                 @downloader.retrieve_url_for(language: "english", team: "asap"))
  end
  
  def test_must_return_the_first_url_found_for_the_given_language_if_team_nil
     assert_equal('http://toto.com/original/21/3', 
                 @downloader.retrieve_url_for(language: "french", team: nil))
  end

  def test_must_return_nil_if_no_language_is_given
    assert_nil @downloader.retrieve_url_for(team: "hhh")
  end
end

