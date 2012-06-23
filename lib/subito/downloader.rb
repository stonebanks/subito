$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/config'
require 'subito/browser'

module Subito
  class Downloader
    attr_accessor :hash,:url#,:tv_show_feature
    def initialize(hash_urls)
      @hash = hash_urls
    end
        
    def retrieve_url_for(args)
      args = {:language => nil, :team => nil}.merge(args)
      team = args[:team]
      language = args[:language]
      nil
      if team.nil?
        scp_level_hash = Array(hash.find {|k,v| v.has_key? language}).last
        SConfig.instance.ressources_subsite_name + scp_level_hash[language].first unless scp_level_hash.nil? 
      elsif hash.has_key? team and hash[team].has_key? language
        SConfig.instance.ressources_subsite_name + hash[team][language].first
      elsif real_team = hash.keys.detect {|k| k.include? team}
        SConfig.instance.ressources_subsite_name + hash[real_team][language].first if hash[real_team].has_key? language
      end
    end

    def download(test = url)
      Browser.instance.get(test) do |result|
       # filename = tv_show_feature.raw_name[/^(.*\.)[\d\w]{3}$/i,1] + "srt"
        result.save if result.kind_of? Mechanize::File
      end unless test.nil?
    end

  end
end
