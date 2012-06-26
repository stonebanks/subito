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
    flexmock(Verbose).new_instances(:instance).should_receive(:msg).with(String, Symbol).and_return(nil)
    t = ([('a'..'z'),(0..9)].map{|i| i.to_a}).flatten
    r=  (t<<['(',')','.']).flatten
    @name = (0..30).map{r.sample}.join
    @team = (0..4).map {t.sample}.join
    @show = @name+"."+ ["s01e09", '109', '01x09', '1x09'].sample + ".hdtv-"+@team+".avi"
    @showfeature = ShowFeature.new
    @showfeature.parse_show @show
  end 

  def test_should_return_the_name_of_the_show
    assert_equal @name.tr_s('.',' '),@showfeature.name
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

  def test_dyn_replace_must_change_the_value_of_the_given_attribute
    @showfeature.dyn_replace :name=, "something_that_is_not_a_random_generated_stuff"
    assert_equal "something_that_is_not_a_random_generated_stuff", @showfeature.name
  end

  def test_retrieve_id_must_return_nil_if_name_nil
    assert_nil @showfeature.retrieve_id nil
  end

  def test_id_must_be_set_if_block_given
    showfeature = ShowFeature.new
    assert_block do 
      showfeature.parse_show(@show) do |s|
        showfeature.dyn_replace :name=, "something_that_is_not_a_random_generated_stuff"
      end 
      showfeature.id == "42"
    end
  end

  def test_all_attrs_should_return_nil
    showfeature = ShowFeature.new
    showfeature.parse_show "ff.s01e09.avi"
    assert_block do
      [:name, :episode, :season, :team, :id].collect!{|x| showfeature.send(x)}.all?do |x|
        x.nil?
      end
    end
  end
  
end

