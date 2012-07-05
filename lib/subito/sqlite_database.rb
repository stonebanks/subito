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
require 'sqlite3'

module Subito
  class SQliteDatabase
    include Singleton
    attr_reader :filename

    def initialize(filename = '.subito.store')
      @filename = filename
    end

    def write 
      Dir.chdir Dir.home do 
        verbose = Verbose.instance
        verbose.msg("Creating Database...")    
        FileUtils.rm_f(self.filename)
        db = SQLite3::Database.new @filename
        # Create a database
        rows = db.execute "create table if not exists showsid (name varchar(255),val int );"
        verbose.msg "Connecting to #{SConfig.instance.ressources_subsite_name}", :debug
        page = Browser.instance.get SConfig.instance.ressources_subsite_name
        nodeset = page.parser.xpath SConfig.instance.yaml_database_data_xpath
        nodeset.each do |node|
          db.execute "insert into showsid values ( ?, ? )", [node.text.downcase, node.attr('value')]
        end  
      end
    end

    def populate_db(args, proc)
      FileUtils.rm_f(self.filename)
      db = SQLite3::Database.new @filename
      # Create a database
      db.execute "create table if not exists showsid (name varchar(255),val int );"
      args.each do |node|
        db.execute "insert into showsid values ( ?, ? )", proc.call(node)
      end
    end
  end
end
