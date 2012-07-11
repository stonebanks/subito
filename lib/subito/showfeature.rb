# This file is part of Subito.

# Subito is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Subito is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Subito.  If not, see <http://www.gnu.org/licenses/>.

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
        @id = Database.instance.get(name) 
        if @id.nil?
          sim = Database.instance.get_shows_similar_to name,0.89
          Verbose.instance.msg "#{name} is not in database,\
 maybe you meant a show in the following list :#{sim.keys}" unless sim.empty?
        end
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
