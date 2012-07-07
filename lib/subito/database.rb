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
require 'singleton'
require 'subito'
require 'fuzzystringmatch'
module Subito
  # This class wraps instance of database accessor objects, 
  # 
  #
  # @since 0.3.0
  class Database
    include Singleton
    attr_accessor :db
    # Constructor
    def initialize
      begin
        Kernel.send(:gem, 'sqlite3')
        Kernel.require 'sqlite3'
        require 'subito/databases/sqlite_database'
        @db = SQLiteDatabase.new
      rescue Gem::LoadError
        require 'yaml'
        require 'subito/databases/yml_database'
        @db = YamlDatabase.new
      end
    end
    
    # Write the database, elements in the base are name_of_show => id
    def write
      Dir.chdir Dir.home do 
        verbose = Verbose.instance
        verbose.msg("Creating Database...") 
        verbose.msg "Connecting to #{SConfig.instance.ressources_subsite_name}", :debug 
        page = Browser.instance.get SConfig.instance.ressources_subsite_name
        verbose.msg "Parsing the page", :debug
        nodeset = page.parser.xpath SConfig.instance.database_data_xpath
        @db.populate_db(nodeset, Proc.new{|x| [x.text.downcase.strip, x.attr('value')]})
      end
    end

    # Return the id of the show for the given name
    #
    # @param [String] name the name of the tv show
    # @return [String] the corresponding id
    def get(name)
      Dir.chdir Dir.home do
        unless File.exists? @db.filename
          Verbose.instance.msg "#{filename} does not exist, It needed to be created", :debug
          write
        end
        @db.find_id(name)
      end
    end

    # Return all shows which names are similar to the given one 
    #
    # @param [String] showname the name of a tv show
    # @param [Float] the threshold from which similarity is considered
    #
    # @return [Hash] An hash of similar shows
    def get_shows_similar_to(showname, jwthreshold = 0.7)
      jarow = FuzzyStringMatch::JaroWinkler.create( :pure )
      @db.process Proc.new {|x| jarow.getDistance(showname,x) >= jwthreshold}
    end
  end
end
