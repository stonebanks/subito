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

require 'singleton'
require 'subito'

module Subito
  # This class wraps some mechanize routine
  #
  # @since 0.2.0
  class Browser
    include Singleton
    attr_reader :agent
    # Constructor
    def initialize
      @agent = Mechanize.new
    end

    # Connect to a page at the given url
    #
    # @param [String] url the complement of the web page root
    # @return [Mechanize::Page] an html page
    def get(url)
      verbose = Verbose.instance
      begin
        ret = @agent.get(url, [], url)
        verbose.msg "Connection has succeeded", :debug
        yield(ret) if block_given?
        ret
      rescue Mechanize::Error
        verbose.msg "Connection error", :error
        raise WebSiteNotReachableError
      end
    end
  end
end

