$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/showfeature'
require 'flexmock/test_unit'

include Subito

class ShowFeatureTest < Test::Unit::TestCase
  include FlexMock::TestCase
  def setup
    flexmock(YamlDatabase).new_instances(:instance).should_receive(:get).with(String).and_return("42")
    t = ([('a'..'z'),(0..9)].map{|i| i.to_a}).flatten
    r=  (t<<['(',')','.']).flatten
    @name = (0..30).map{r.sample}.join
    @team = (0..4).map {t.sample}.join
    @show = @name+"."+ ["s01e09", '109', '01x09', '1x09'].sample + ".hdtv-"+@team+".avi"
    @showfeature = ShowFeature.new
    @showfeature.parse_show @show
  end 

  def test_should_return_the_name_of_the_show
    assert_equal @name.gsub(/\./," "),@showfeature.name
  end

  def test_should_return_the_episode_of_the_show
    assert_equal "09",@showfeature.episode
  end
  def test_should_return_the_season_of_the_show
    assert_equal "01", @showfeature.season
  end
  def test_should_return_the_team_of_the_show
    assert_equal @team, @showfeature.team
  end
  
end
