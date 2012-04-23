$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'get_tv_show_feature'

include Subito
include TVShowFeature
class TestGetTVShowName < Test::Unit::TestCase
  def test_must_return_an_hash_with_all_show_features
    assert_equal({ :name => 'up all night',
                   :season => '01',
                   :episode => '01',
                   :team => 'lol',
                   :is720p => false,
                   :acquisition => 'hdtv',
                   :raw_name => 'Up.All.Night.S01E01.HDTV.XviD-LOL.avi' },
                 parse_show("Up.All.Night.S01E01.HDTV.XviD-LOL.avi"))
  end

  def test_must_return_an_correct_hash_when_episode_season_is_formatted_as_dxdd
    assert_equal({ :name => 'up all night',
                   :season => '01',
                   :episode => '01',
                   :team => 'lol',
                   :is720p => false,
                   :acquisition => 'hdtv',
                   :raw_name => 'Up.All.Night.1x01.HDTV.XviD-LOL.avi' },
                 parse_show("Up.All.Night.1x01.HDTV.XviD-LOL.avi"))
  end

  def test_must_return_an_correct_hash_when_episode_season_is_formatted_as_dxdd
    assert_equal({ :name => 'up all night',
                   :season => '01',
                   :episode => '01',
                   :team => 'lol',
                   :is720p => false,
                   :acquisition => 'hdtv',
                   :raw_name => 'Up.All.Night.1x01.HDTV.XviD-LOL.avi' },
                 parse_show("Up.All.Night.1x01.HDTV.XviD-LOL.avi"))
  end

  def test_must_return_an_correct_hash_when_episode_season_is_formatted_as_ddd
    assert_equal({ :name => 'up all night',
                   :season => '01',
                   :episode => '01',
                   :team => 'lol',
                   :is720p => false,
                   :acquisition => 'hdtv',
                   :raw_name => 'Up.All.Night.101.HDTV.XviD-LOL.avi' },
                 parse_show("Up.All.Night.101.HDTV.XviD-LOL.avi"))
  end

 def test_must_have_a_nil_parameter_when_info_is_not_available
    assert_equal({ :name => 'up all night',
                   :season => '01',
                   :episode => '01',
                   :team => 'lol',
                   :is720p => false,
                   :acquisition => nil,
                   :raw_name => 'Up.All.Night.01x01.XviD-LOL.avi' },
                 parse_show("Up.All.Night.01x01.XviD-LOL.avi"))
  end

  def test_must_return_an_correct_hash_when_episode_season_is_formatted_as_dddd
    assert_equal({ :name => 'up all night',
                   :season => '01',
                   :episode => '01',
                   :team => 'lol',
                   :is720p => false,
                   :acquisition => 'hdtv',
                   :raw_name => 'Up.All.Night.0101.HDTV.XviD-LOL.avi'},
                 parse_show("Up.All.Night.0101.HDTV.XviD-LOL.avi"))
  end

  def test_must_return_an_empty_hash_if_it_is_not_an_avi
    assert_equal({}, parse_show('toto'))
  end

  def test_should_raise_an_exception_if_arg_is_not_a_string
    assert_raises BadTypeError do
      parse_show nil
    end
  end
end
