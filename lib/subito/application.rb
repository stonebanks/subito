$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/searcher'
require 'subito/yml_database'
require 'subito/downloader'
require 'subito/subtitles_urls_getter'
require 'subito/verbose'

module Subito
  class Application
    def self.run(options)
      p options
      # Verbose class instanciation
      verbose = Verbose.instance
      verbose.set(options[:v],STDOUT)
      verbose.msg("Application is running with create_database option", :debug)
      if options[:create_database]
        verbose.msg("Creating Database...")
        Dir.chdir(Dir.home){YamlDatabase.instance.write }
        verbose.msg("Database creation succeed", :debug)
      end
       
      verbose.msg("Change directory, going in #{options[:working_directory]}", :debug)
      # Going in working directory
      Dir.chdir(options[:working_directory]) do 
        verbose.msg("Considering only files following pattern #{options[:name]}", :debug)
        Dir.glob(options[:name]).each do |show|
          verbose.msg("Computing show : #{show}")
          basename = show[/^(.*\.)[\d\w]{3}$/i,1]
          unless (File.exists? basename+"srt")
            s = ShowFeature.new
            s.parse_show(show) do |s| 
              unless options[:as_if][s.name].nil?
              Verbose.instance.msg("Replacing #{s.name} by #{options[:as_if][s.name]}", :debug)
              s.dyn_replace(:name=, options[:as_if][s.name])
              end
            end
            searcher = Searcher.new
            page = searcher.search(id: s.id, season: s.season, episode: s.episode)
            subtitles_urls = SubtitlesUrlsGetter.new(page).run
            downloader = Downloader.new(subtitles_urls)
            language = SConfig.instance.send("language_#{options[:language]}".to_sym)
            url = downloader.retrieve_url_for(language: language, team: s.team)
            res = downloader.download(url,options[:to_rename] ? basename + "srt": nil)
          else
            verbose.msg "#{basename+ "srt"} already exists!"
          end
        end
      end
    end
  end
end
