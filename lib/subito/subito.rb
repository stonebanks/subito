require 'optparse'
require 'subito/config'

module Subito
  class SubitoArgParser
    
    def self.parse(args)
      options = {
        :language => "en", 
        :create_database =>false, 
        :working_directory => ".", 
        :name => "*.{avi,mp4,mkv}", 
        :to_rename => true }

      languages = SConfig.instance.data["language"]

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: subito [options] "
        opts.separator ""
        opts.separator "Specific options:"
        opts.on("-l","--language LANGUAGE", languages, "Download the LANGUAGE version of the subtitle file, option are #{languages}") do |lang|
          options[:language] = lang
        end
        opts.separator ""
        opts.on("-d","--create-database", "Create or update show database") do |db|
          options[:create_database] = db
        end
        opts.on("-w","--directory DIR","Run in directory DIR") do |dir| 
          options[:working_directory] = dir
        end
        opts.on("-n","--name PATTERN","Run for the show called RAW_NAME") do |raw_name| 
          option[:name] = raw_name
        end
        opts.on("--[no-]renaming", "Rename the file as the raw name (default)") do |t| 
          options[:to_rename] = t
        end
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end
      opts.parse! args
      options
    end
    
  end
end
