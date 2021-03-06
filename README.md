## Subito ##
Subito is a utility application easing tv show subtitles download.

### Requirements ###
* Ruby >1.9
* Mechanize
* fuzzy-string-match_pure
* SQLite3 (optional)

and:

* Flexmock
* Fakeweb
 to run tests.

To install dependencies, run in the application directory root:

    $ bundle install --without test # if you want to use sqlite

or 

    $ bundle install --without test extra # otherwise


On Windows, you may need to install _Development-Kit_ and follow the [installation instructions](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) along with [RubyInstaller](http://rubyinstaller.org/downloads/)

__Note:__ Colors in terminal is not available on windows

### Usage ###
You can find help by launching 

    $ cd path/to/subito/directory/bin
    $ ./subito --help

or

    $ ruby subito --help

### TODO and Known issues ###
* Read the TODO file.
* <http://www.addic7ed.com>, the website on which the application relies on, doesn't allow any more downloads when non-premium user exceeds a certain amount. But there's many workarounds to prevent this...;)
* Issues with JRuby

### License ###
Copyright (c) 2012 Allan Seymour

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
