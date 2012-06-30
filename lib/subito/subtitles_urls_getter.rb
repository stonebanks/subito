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
          verbose.msg "Team: #{version}", :debug
          payload = document.xpath("//td[@class='language']|//td[@class='language']//following-sibling::td")
          payload.each_slice(4) do |m|
            urls = m[2].elements
            language = m[0].child.text[/[^\w]*(\w+)/,1]
            verbose.msg "  Language: #{language}", :debug
            url = urls[urls.size - 1 ].attribute("href").value
            verbose.msg "   Url: #{url}", :debug
            @hash_urls[version.downcase.strip][language.downcase.strip] <<  url if m[1].child.text.strip[/^Completed/]
          end
        end
        verbose.msg "Subtitles: #{@hash_urls}", :debug
      end
      @hash_urls
    end
  end
end

