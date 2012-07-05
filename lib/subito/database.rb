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
module Subito
  # This class wraps instance of database accessor object, 
  # 
  #
  # @since 0.3.0
  class Database

    attr_accessor :db
    include Singleton
    # Constructor
    def initialize
      begin
        Kernel.send(:gem, 'sqlite3')
        Kernel.require 'sqlite3'
        @db = SQLiteDatabase.new
      rescue Gem::LoadError
        require 'yaml'
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
        nodeset = page.parser.xpath SConfig.instance.yaml_database_data_xpath
        @db.populate_db(nodeset, Proc.new{|x| [x.text.downcase.strip, x.attr('value')]})
      end
    end
  end
end
