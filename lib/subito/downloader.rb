$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/config'
require 'subito/browser'

module Subito
  class Downloader
    attr_accessor :hash
    def initialize(hash_urls)
      @hash = hash_urls
    end
        
    def retrieve_url_for(args = {})
      args = {:language => nil, :team => nil}.merge(args)
      team = args[:team]
      language = args[:language]
      nil
      if team.nil?
        scp_level_hash = Array(hash.find {|k,v| v.has_key? language}).last
        SConfig.instance.ressources_subsite_name + scp_level_hash[language].first unless scp_level_hash.nil? 
      elsif hash.has_key? team and hash[team].has_key? language
        SConfig.instance.ressources_subsite_name + hash[team][language].first
      elsif result = hash.find {|k,v| k.include? team and v.has_key? language}
        SConfig.instance.ressources_subsite_name + result.last[language].first unless result.nil?
      end
    end

    def download(url, filename = nil)
      Browser.instance.get(url) do |result|
        result.save_as(filename) unless result.kind_of? Mechanize::Page
      end unless url.nil?
    end

  end
end
