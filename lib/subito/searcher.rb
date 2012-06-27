$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/config'
require 'subito/browser'
require 'subito/verbose'

module Subito
  
  # This class is used to connect the application to the subtitles page
  #
  # @since 0.2.0
  class Searcher
    
    # Connect to the right page depending on the features of the the tv show
    #
    # @param [Hash] args the arguments to create the url of the page
    # @option opts [String] :id The id of the show
    # @option opts [String] :season the season of the show
    # @option opts [String] :episode the episode of the show
    # @return [Mechanize::Page] an html page
    def search(args = {})
      erb = ERB.new SConfig.instance.ressources_searching_url
      args = {:id => nil, :season => nil, :episode => nil}.merge(args)
      nil
      verbose = Verbose.instance
      unless args.has_value? nil
        verbose.msg "Connecting to subtitles page parameters are #{args}", :debug
        connect erb.result(binding)
      else
        
      end
    end
    
    private
    # Connect to a page at the given url
    #
    # @param [String] url the complement of the web page root
    # @return [Mechanize::Page] an html page
    def connect(url = "")
        Browser.instance.get (SConfig.instance.ressources_subsite_name+url)
    end
    
  end

end
