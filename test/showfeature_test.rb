$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/showfeature'

include Subito

class TestShowFeature < Test::Unit::TestCase
  def setup
    @showfeature = ShowFeature.new
    t = ([('a'..'z'),(0..9)].map{|i| i.to_a}).flatten
    r=  (t<<['(',')','.']).flatten
    @name = (0..30).map{r.sample}.join
    @team = (0..4).map {t.sample}.join
    @show = @name+"."+ ["s01e03", '103', '01x03', '1x03'].sample + ".hdtv-"+@team+".avi"
    @showfeature.parse_show @show
  end 

  def test_should_return_the_name_of_the_show
    assert_equal @name.gsub(/\./," "),@showfeature.name
  end

  def test_should_return_the_episode_of_the_show
    assert_equal "03",@showfeature.episode
  end
  def test_should_return_the_season_of_the_show
    assert_equal "01", @showfeature.season
  end
  def test_should_return_the_team_of_the_show
    assert_equal @team, @showfeature.team
  end
  
end
