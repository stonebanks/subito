$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/config'
require 'subito/browser'

module Subito
  
  # This class is used to connect the application to the subtitles page
  #
  # @since 0.2.0
  class Searcher
    
    # Search 
    #
    # @param [String] url the complement of the web page root
    # @return [Mechanize::Page] an html page
    def search(args = {})
      erb = ERB.new SConfig.instance.ressources_searching_url
      args = {:id => nil, :season => nil, :episode => nil}.merge(args)
      nil
      connect erb.result(binding) unless args.has_value? nil
    end
    
    private
    # Connect to a page
    #
    # @param [String] url the complement of the web page root
    # @return [Mechanize::Page] an html page
    def connect(url = "")
        Browser.instance.get (SConfig.instance.ressources_subsite_name+url)
    end
    
  end

end
