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
require 'erb'
require 'yaml'
require 'singleton'

module Subito
  class SConfig
    include Singleton
    attr_reader :data
    def initialize
      @data = YAML::load_file(File.join(File.dirname(__FILE__),'..', 'config.yml'))
      self.data.keys.each do |key|
        define_methods(key, self.data[key].keys)
      end
    end


    def define_methods(prefix_name, names)
      names.each do |name|
        function = prefix_name+"_"+name
        self.class.class_eval <<-EOS
         def #{function}
           self.data["#{prefix_name}"]["#{name}"]
         end
        EOS
      end
    end
  end
end
