$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/config'
require 'subito/browser'

module Subito
  class Downloader
    attr_accessor :hash,:url,:tv_show_feature
    def initialize(hash_urls, tv_show_feature)
      @hash = hash_urls
      @tv_show_feature = tv_show_feature
    end
        
    def retrieve_url_for(language)
      nil
      team = tv_show_feature.team
      if hash.has_key? team and hash[team].has_key? language
        url = SConfig.instance.ressources_subsite_name + hash[team][language].first
      elsif (real_team = hash.keys.detect {|k| k.include? team})
        url = SConfig.instance.ressources_subsite_name + hash[real_team][language].first if (hash[real_team].has_key? language)
      end
    end

    def download(test = @url)
      Browser.instance.get(test) do |result|
        filename = tv_show_feature.raw_name[/^(.*\.)[\d\w]{3}$/i,1] + "srt"
        result.save_as(filename) if result.kind_of? Mechanize::File
      end unless test.nil?
    end

  end
end
