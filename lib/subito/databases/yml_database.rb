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
    
    def process(proc)
      @dictionnary.select do |k,v| 
       # processor.getDistance(  showname, k)  >= threshold
        proc.call(k)
      end
    end
  end
end
