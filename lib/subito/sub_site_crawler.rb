require 'mechanize'
require 'singleton'
require 'subito/config'

# SUBSITENAME = "http://www.addic7ed.com"
# Search_url = ERB <<-EOF
# http://www.addic7ed.com/search.php?search=<%= name%>+<%= season%>x<%= episode%>&Submit=Search
# EOF

module Subito

  # class SubSiteCrawler
  #   def initialize(agent = Mechanize.new)
  #     @agent = agent
  #   end
    
  #   def connect
  #     @page = @agent.get SUBSITENAME
  
  #   end

  #   def search(str)
  #     hash = TVShowFeature::parse_show(str)
  #     get_results( hash[:name])
  #   end
  # end
  WebSiteNotReachableError = Class.new Mechanize::Error
  
  class Browser
    include Singleton

    attr_reader :agent
    def initialize
      @agent = Mechanize.new
    end
  end


  class SubSiteCrawlerConnector
    # def initialize #(browser = Browser.instance)
    #   @agent = agent
    # end
    def connect(url = "")
      begin
        agent = Browser.instance.agent
        agent.get (Config.instance.subsite_name+url)
      rescue Mechanize::Error
        raise WebSiteNotReachableError
      end
    end

    def search(tv_show_feature)
      erb = ERB.new Config.instance.searching_url
      name = tv_show_feature.name
      season = tv_show_feature.season
      episode = tv_show_feature.episode
      connect erb.result(binding)
    end
  end
  

  class SubSiteCrawlerSearcher
    
  end
  
  class SubSiteCrawler
    def initialize(connector = SubSiteCrawlerConnector.new)
      @connector = connector
      @connector.connect
    end
    
  end
end
# module SubIto
#   class InfoDL
#     attr_accessor :version, :dl_urls
#     def initialize
#       @version = String.new
#       @dl_urls = {:language =>"", :completed =>, :url =>""}
#     end

#     def to_s
#       puts "#{@version}  #{@dl_urls}"
#       endx
#     end
#   end

#   class SubSiteCrawler
#     def initialize
#       @agent = Mechanize.new do |agent|
#         agent.user_agent_alias = 'Mac Safari'
#       end
#       @infos_dl_array = Hash.new
#     end

#     #connect to addicted webpage and search the show
#     def connect_to_page(hash_tv_show_feature)

#       name,season,episode = hash_tv_show_feature[:name], hash_tv_show_feature[:season], hash_tv_show_feature[:episode]
#       begin
#         results = nil
#         @agent.get SubSiteName do |page|
#           search_result = page.form_with(:name => 'form1') do |search|
#             search.search = name+" "+season+"x"+episode
#           end.submit
#           results =  search_result.links.find do |l| 
#             l.text.include? season+"x"+episode
#           end.click
#           results
#         end
#       rescue SocketError
#         raise "Connection issue"
#       end
#       page
#     end

#     def parse_page(page)
#       node_array = page.parser.xpath("//div[@id='container95m']//table[@class='tabel95' and @width]")
#       node_array.each do |node|
#         doc = Nokogiri::XML::Document.new
#         doc << node
#         version = doc.xpath('//td[@class = "NewsTitle"]').first.text[/Version (.*)/,1]

#         doc.xpath("//td[@class='language']|//td[@class='language']//following-sibling::td").each_slice(4) do |m|
#           urls = m[2].elements
#           u = { :language  => m[0].child.text[/\n(\w+)/,1],
#             :completed => m[1].child.text[/\n([0-9A-Za-z.% ]+)/,1],
#             :url       => urls[urls.size - 1 ].attribute("href").value
#           }

#           @infos_dl_array <<{version => u}
#         end
#       end
#     end
#   end


#   def find_show(hash_tv_show_feature)

#   end

#   module SubSiteCrawlerImpl
#     extend self
#     def get_version(doc, xpath_str)
#       doc.xpath(xpath_str).first.text
#     end
#   end
# end
