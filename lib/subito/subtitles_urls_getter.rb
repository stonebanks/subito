require 'subito/config'
require 'subito/browser'


module Subito 

  class SubtitlesUrlsGetter
    attr_reader :hash_url, :page
    def initialize(page = Browser.instance.agent.page)
      @page = page
      @hash_urls = Hash.new do |hash, key| 
        hash[hey] = Hash.new {|h,k| h[k]= []} 
      end
    end
  end
end
