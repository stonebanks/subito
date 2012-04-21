require 'mechanize'

SubSiteName = "http://www.addic7ed.com"


class InfoDL
  attr_accessor :version, :dl_urls
  def initialize
    @version = String.new
    @dl_urls = {:language =>"", :completed =>, :url =>""}
  end
end

class SubSiteCrawler

  def initialize
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
    end
  end

  def connect_to_page(hash_tv_show_feature)
    
    name,season,episode = hash_tv_show_feature[:name], hash_tv_show_feature[:season], hash_tv_show_feature[:episode]
    begin
      page = @agent.get SubSiteName do |page|
        search_result = page.form_with(:name => 'form1') do |search|
          search.search = name+" "+season+"x"+episode
        end.submit
        results =  search_result.links.find do |l| 
          l.text.include? season+"x"+episode
        end.click
      end
    rescue SocketError
      raise "Connection issue"
    end
    page
  end

  def parse_page(page)
    node_array = page.parser.xpath("//div[@id='container95m']//table[@class='tabel95' and @width]")
    infosDL_array = []
    node_array.each do |node|
      info_dl = InfosDL.new
      doc = Nokogiri::XML::Document.new
      doc << node
      #doc.xpath('//td[@class]')
      
    end
  end


  
end
