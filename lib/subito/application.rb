$:.unshift File.join(File.dirname(__FILE__), '..')

require 'subito/yml_database'
module Subito
  class Application
    def self.run(options)
      p options
      #build database
      if options[:create_database]
        Dir.chdir(Dir.home){YamlDatabase.instance.write }
      end
      
      #change directory
      Dir.chdir(options[:working_directory]) do 
        Dir.glob(options[:name]).each do |show|
          s = ShowFeature.new
          s.parse_show show
          searcher = Searcher.new
          page = searcher.search(id: s.id, season: s.season, episode: s.episode)
          subtitles_urls = SubtitlesUrlsGetter.new(page).run
          downloader = Downloader.new(subtitles_urls)
          url = downloader.retrieve_url_for(language: options[:language], team: options[:team])
          downloader.download(url,options[:to_rename] ? show[/^(.*\.)[\d\w]{3}$/i,1] + "srt": nil)
        end
      end
    end
  end
end
