$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/spec'
require 'minitest/autorun'
require 'subito/showfeature'

include Subito

def create_a_show
  t = ([('a'..'z'),(0..9)].map{|i| i.to_a}).flatten
  r = (t<<['(',')','.']).flatten
  name = (0..30).map{r.sample}.join
  team = (0..4).map {t.sample}.join
  show = name+"."+ ["s01e09", '109', '01x09', '1x09'].sample + ".hdtv-"+team+".avi"
  show
end

describe ShowFeature do
  before do 
    @show = create_a_show
  end
 
  it "can be created with no arguments" do 
    ShowFeature.new().must_be_instance_of ShowFeature
  end

  it "can be created with a string argument" do 
    ShowFeature.new(@show).raw_name.must_equal @show
  end
 
  describe ".parse" do 
    before do 
      @sf = ShowFeature.new(@show)
    end
    it "returns an hash" do 
      @sf.parse.must_be_instance_of Hash
    end
    it "parses the show and returns the right elements" do 
      assert_block do 
        @result.all? {|stuff| @show.include? stuff}
      end
    end
    
  end
 

end
