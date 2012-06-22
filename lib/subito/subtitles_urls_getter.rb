$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/config'
require 'subito/browser'


module Subito 

  class SubtitlesUrlsGetter
    attr_reader :hash_urls, :page
    def initialize(page = Browser.instance.agent.page)
      @page = page
      @hash_urls = Hash.new do |hash, key| 
        hash[key] = Hash.new {|h,k| h[k]= []} 
      end
    end


    def run(xpath_sections = SConfig.instance.xpaths_sections)
      sections = @page.parser.xpath(xpath_sections)
      sections.each do |node|
        document = Nokogiri::XML::Document.new
        document << node
        version = document.xpath('//td[@class = "NewsTitle"]').first.text[/Version (.*),.*MBs/,1]
        payload = document.xpath("//td[@class='language']|//td[@class='language']//following-sibling::td")
        payload.each_slice(4) do |m|
          urls = m[2].elements
          language = m[0].child.text[/[^\w]*(\w+)/,1]
          url = urls[urls.size - 1 ].attribute("href").value
          @hash_urls[version.downcase.strip][language.downcase.strip] <<  url if m[1].child.text.strip[/^Completed/]
        end
      end
      @hash_urls
    end
  end
end

