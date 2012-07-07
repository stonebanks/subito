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
require 'colored'
module Subito
  VERSION = "0.3.0"
  ROOT = File.expand_path(File.dirname(__FILE__))
  Dir.glob(File.join(ROOT, "subito",'*.rb')).reject{|i| i=~/_database/}.
    each  do |file|
    require file
  end
end
