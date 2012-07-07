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

  # This class , 
  # 
  #
  # @since 0.3.0
  class SQLiteDatabase
    attr_reader :filename

    def initialize(filename = '.subito.db')
      @filename = filename
    end

    def populate_db(args, proc)
      FileUtils.rm_f(@filename)
      @db = SQLite3::Database.new @filename
      @db.default_synchronous='off'
      # Create a database
      @db.execute "create table if not exists showsid (name varchar(255),id int );"
      args.each do |node|
        @db.execute "insert into showsid values ( ?, ? )", proc.call(node)
      end
    end

    def find_id(name)
      @db = SQLite3::Database.new @filename if @db.nil?
      ret = @db.execute "select id from showsid where name=?",name
      ret.flatten.first
    end

    def process(proc)
      @db.create_function("jarowp",1) do |func,x|
        func.result = 1 if proc.call(x)
      end
      Hash[@db.execute "select * from showsid where jarowp(name)=1"]
    end
  end
end
