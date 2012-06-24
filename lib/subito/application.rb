$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/searcher'
require 'subito/yml_database'
require 'subito/downloader'
require 'subito/subtitles_urls_getter'

module Subito
  class Application
    def self.run(options)
      p options
      verbose = Verbose.instance
      verbose.set (options[:v], STDOUT, Logger.new(STDOUT))
      verbose.msg("Application is running with create_database option", :info)
      if options[:create_database]
        verbose.msg("Creating Database...")
        Dir.chdir(Dir.home){YamlDatabase.instance.write }
      end
      
      Dir.chdir(options[:working_directory]) do 
        Dir.glob(options[:name]).each do |show|
          unless (File.exists? show[/^(.*\.)[\d\w]{3}$/i,1] )
            s = ShowFeature.new
            s.parse_show(show) do |s|
              s.dyn_replace(:name=, options[:as_if][s.name]) unless options[:as_if][s.name].nil?
            end
            searcher = Searcher.new
            page = searcher.search(id: s.id, season: s.season, episode: s.episode)
            subtitles_urls = SubtitlesUrlsGetter.new(page).run
            downloader = Downloader.new(subtitles_urls)
            language = SConfig.instance.send("language_#{options[:language]}".to_sym)
            url = downloader.retrieve_url_for(language: language, team: s.team)
            res = downloader.download(url,options[:to_rename] ? show[/^(.*\.)[\d\w]{3}$/i,1] + "srt": nil)
          end
        end
      end
    end
  end
end
