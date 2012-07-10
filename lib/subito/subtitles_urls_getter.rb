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
require 'subito'


module Subito
 
  # This class provides methods for parsing the subtitles page
  #
  # @since 0.2.0
  class SubtitlesUrlsGetter
    attr_reader :hash_urls, :page
    # Constructor
    #
    # @param [Mechanize::Page] page
    def initialize(page = Browser.instance.agent.page)
      @page = page
      @hash_urls = Hash.new do |hash, key| 
        hash[key] = Hash.new {|h,k| h[k]= []} 
      end
    end

    # Parse the subtitles page 
    #
    # @param [String] xpath_sections xpath to retrieve necessary elements
    # @return [Hash] team =>  {language =>[url1, ul2,...]}
    def run(xpath_sections = SConfig.instance.xpaths_sections)
      unless @page.nil?
        verbose = Verbose.instance
        sections = @page.parser.xpath(xpath_sections)
        sections.each do |node|
          verbose.msg "Computing node", :debug
          document = Nokogiri::XML::Document.new
          document << node
          version = document.xpath('//td[@class = "NewsTitle"]').first.text[/Version (.*),.*MBs/,1]
          # some version works also with other team
          works_with_text = document.xpath('//td[@class="newsDate"][contains(text(), "Works with")]').text[/Works with(.*)$/,1]
          works_with = works_with_text.nil? ? [] : works_with_text.split(',')
          verbose.msg "Team: #{version}", :debug
          payload = document.xpath("//td[@class='language']|//td[@class='language']//following-sibling::td")
          payload.each_slice(4) do |m|
            urls = m[2].elements
            language = m[0].child.text[/[^\w]*(\w+)/,1]
            verbose.msg "  Language: #{language}", :debug
            url = urls[urls.size - 1 ].attribute("href").value
            verbose.msg "   Url: #{url}", :debug
            (works_with << version).collect {|x| @hash_urls[x.downcase.strip][language.downcase.strip] <<  url if m[1].child.text.strip[/^Completed/] }
#            @hash_urls[version.downcase.strip][language.downcase.strip] <<  url if m[1].child.text.strip[/^Completed/]
          end
        end
        verbose.msg "Subtitles: #{@hash_urls}", :debug
      end
      @hash_urls
    end
  end
end

