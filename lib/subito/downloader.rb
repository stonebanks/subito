$:.unshift File.join(File.dirname(__FILE__), '..')
require 'mechanize'
require 'subito'

module Subito
  # This class provides methods for parsing the subtitles page
  #
  # @since 0.2.0
  class Downloader
    attr_accessor :hash
    
    # Constructor
    def initialize(hash_urls)
      @hash = hash_urls
    end
    
    # Search in a hash of subtitles (see SubtitlesUrlsGetter#run) the right urls given the language and team
    #
    # @param [Hash] args 
    # @option args [String] :language The language the user want the subtitles to be in
    # @option args [String] :team the team that encoded the video tv show
    # @return [Mechanize::Page] an link to the subtitles
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
    
    # Download a file given the url where it's from
    #
    # @param [String] url
    # @return [Mechanize::Page] a link to the subtitles
    def download(url, filename = nil)
      Browser.instance.get(url) do |result| 
        verbose = Verbose.instance
        unless result.kind_of? Mechanize::Page
          result.save_as(filename) 
          verbose.msg "Download completed #{filename}"
        end
      end unless url.nil?
    end

  end
end
