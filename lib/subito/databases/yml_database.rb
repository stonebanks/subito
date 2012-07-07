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

require 'yaml'

module Subito
  # This class contains methods used for the access of the yaml database
  #
  # @since 0.2.0
  class YamlDatabase
 #   include Singleton
    # attr_reader
    attr_reader :filename
    # attr_accessor
    attr_accessor :dictionnary
    # Constructor
    def initialize(filename = '.subito.store')
      @filename, @dictionnary = filename, {}
    end

    # Write the tv shows database, elements in the base are name_of_show => id
    # def write
    #   verbose = Verbose.instance
    #   verbose.msg("Creating Database...")
    #   verbose.msg "Connecting to #{SConfig.instance.ressources_subsite_name}", :debug
    #   page = Browser.instance.get SConfig.instance.ressources_subsite_name
    #   verbose.msg "Parsing the page", :debug
    #   nodeset = page.parser.xpath SConfig.instance.yaml_database_data_xpath
    #   nodeset.each do |node|
    #     @dictionnary[node.text.downcase] = node.attr('value')
    #   end
    #   verbose.msg "Creating Database file in $HOME/#{self.filename}", :debug
    #   Dir.chdir Dir.home do 
    #     File.open(self.filename, 'w') do |out|
    #       YAML.dump(@dictionnary, out)
    #     end      
    #   end
    #   verbose.msg("Database creation succeed", :info)
    #  end

    def populate_db args, proc
      FileUtils.rm_f(self.filename)
      @dictionnary = Hash[*args.collect{|v| proc.call(v)}.flatten] 
      File.open(self.filename, 'w') do |out|
        YAML.dump(@dictionnary, out)
      end
    end

    def find_id(name)
      if self.dictionnary.empty? 
        Verbose.instance.msg "Loading Database...", :debug
        self.dictionnary = YAML.load_file absolute_filename
      end
      id = self.dictionnary[name]
      Verbose.instance.msg("#{name} isn't in database. You may need to update database by running the application with -d option", :debug) if id.nil?
      id
    end
    # Return the id of the show for the given name
    #
    # @param [String] name the name of the tv show
    # @return [String] the corresponding id
    # def get(name)
    #   if self.dictionnary.empty?
    #     absolute_filename = File.join(Dir.home, @filename)
    #     unless File.exists? absolute_filename
    #       Verbose.instance.msg "#{absolute_filename} does not exist, It needed to be created", :debug
    #       write
    #     end
    #     Verbose.instance.msg "Loading Database...", :debug
    #     self.dictionnary = YAML.load_file absolute_filename
    #   end
    #   id = self.dictionnary[name]
    #   Verbose.instance.msg("#{name} isn't in database. You may need to update database by running the application with -d option", :debug) if id.nil?
    #   id
    # end
    
    # # Return all shows which names are similar to the given one 
    # #
    # # @param [String] showname the name of a tv show
    # # @param [Float] the threshold from which similarity is considered
    # #
    # # @return [Hash] An hash of similar shows
    # def get_all_shows_similar_to(showname, threshold =0.7)
    #   jarow = FuzzyStringMatch::JaroWinkler.create( :pure )
    #   @dictionnary.select do |k,v| 
    #     jarow.getDistance(  showname, k)  >= threshold
    #   end
    # end
    
    def process(proc)
      @dictionnary.select do |k,v| 
       # processor.getDistance(  showname, k)  >= threshold
        proc.call(k)
      end
    end
  end
end
