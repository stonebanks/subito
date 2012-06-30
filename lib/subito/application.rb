# This file is part of Subito.

# Subito is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Subito is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Subito.  If not, see <http://www.gnu.org/licenses/>.

$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito'

module Subito
  class Application
    def self.run(options)
      # Verbose class instanciation
      verbose = Verbose.instance
      verbose.set(options[:v],STDOUT)
      verbose.msg "Application is running, option are #{options}", :info
      # Create database if asked
      if options[:create_database]
        verbose.msg("Creating Database...")
        Dir.chdir(Dir.home){YamlDatabase.instance.write }
        verbose.msg("Database creation succeed", :info)
      end
       
      verbose.msg("Change directory, going in #{options[:working_directory]}", :info)
      # Going in working directory
      Dir.chdir(options[:working_directory]) do 
        verbose.msg("Considering only files following pattern #{options[:name]}", :info)
        # Run on all shows matching pattern
        Dir.glob(options[:name]).each do |show|
          verbose.msg("Computing show : #{show}")
          basename = show[/^(.*\.)[\d\w]{3}$/i,1]
          unless (File.exists? basename+"srt")
            s = parse_show show, options
            page = search_subtitles_page(s)
            subtitles_urls = SubtitlesUrlsGetter.new(page).run
            download s, show, subtitles_urls, options
          else
            verbose.msg "#{basename+ "srt"} already exists!"
          end
        end
      end
    end

    private
    
    def self.parse_show show, options
      s = ShowFeature.new
      s.parse_show(show) do |s| 
        unless options[:as_if][s.name].nil?
          Verbose.instance.msg("Replacing #{s.name} by #{options[:as_if][s.name]}", :info)
          s.dyn_replace(:name=, options[:as_if][s.name])
        end
      end
      s
    end

    def self.search_subtitles_page(s)
      searcher = Searcher.new
      Verbose.instance.msg "Connecting to subtitles page", :info
      page = searcher.search(id: s.id, season: s.season, episode: s.episode)
    end

    def self.download(s, show, subtitles_urls, options)
      verbose =  Verbose.instance
      downloader = Downloader.new(subtitles_urls)
      language = SConfig.instance.send("language_#{options[:language]}".to_sym)
      url = downloader.retrieve_url_for(language: language, team: s.team)
      unless url.nil?
        verbose.msg "Downloading subtitle for #{show} from #{url}..." 
        res = downloader.download(url,options[:to_rename] ? show[/^(.*\.)[\d\w]{3}$/i,1] + "srt": nil)
      else
        verbose.msg "Unable to download subtitles for #{show} in #{options[:complete_language]}"
      end
    end

  end
end
