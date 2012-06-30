$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito'

module Subito
  # An instance of this class contains the default elements featuring a show
  # His name, season, episode, team and id
  #
  # @since 0.2.0
  class ShowFeature
    #attr_accessor
    attr_accessor :id, :name, :team, :episode, :season
    PATTERN = /(^[\w\.\(\)]+)\.(\d{3}|s?\d{1,2}[ex]?\d{2})\..*-(.*)\.[\d\w]{3}$/i
 
    # Parse the video filename to find the features
    #
    # @param [String] video_filename the video filename
    # @yield [obj] when a block is given, retrive_id is executed  after the yielded insctructions
    # @yieldparam [ShowFeature] obj self
    def parse_show(video_filename)
      verbose = Verbose.instance
      @name = video_filename[PATTERN, 1].nil? ? nil : video_filename[PATTERN, 1].downcase.tr_s('.',' ')
      @season = video_filename[PATTERN,2].nil? ? nil : "%02d" % video_filename[PATTERN,2][/(\d+).?(\d{2}$)/,1].to_i
      @episode = video_filename[PATTERN,2].nil? ? nil : "%02d" % video_filename[PATTERN,2][/(\d+).?(\d{2}$)/,2].to_i
      @team = video_filename[PATTERN,3].nil? ? nil : video_filename[PATTERN,3].downcase
      if block_given?
        yield(self)
        retrieve_id(@name)
      end
      verbose.msg("#{self.to_s}", :debug)
    end

    # Get the id of the tv show in database for the given name
    #
    # @param [String] name the name of the tv show
    # @return [String] the corresponding id
    def retrieve_id(name)
      nil
      unless name.nil? 
        Verbose.instance.msg "Getting id for #{name}", :debug
        @id = YamlDatabase.instance.get(name) 
      end
    end
    
    # Replace dynamically an attribute with the given value while running
    #
    # @param [Symbol] sym the setter of the attribute
    # @param [String] value new value
    def dyn_replace(sym,value)
      self.send(sym,value.downcase)
    end

    # Overloaded to_s method
    def to_s
      "name :#{name} season:#{season} episode:#{episode} team:#{team} id:#{id}"
    end
  end
end
