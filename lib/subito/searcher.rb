$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/config'
require 'subito/browser'

module Subito
   
  class Searcher
    def connect(url = "")
        Browser.instance.get (SConfig.instance.ressources_subsite_name+url)
    end

    def search(args = {})
      erb = ERB.new SConfig.instance.ressources_searching_url
      args = {:id => nil, :season => nil, :episode => nil}.merge(args)
      nil
      connect erb.result(binding) unless args.has_value? nil
    end
  end

end
