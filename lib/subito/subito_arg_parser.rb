$:.unshift File.join(File.dirname(__FILE__), '..')
require 'optparse'
require 'subito'

module Subito
  # Parse the command line option
  #
  # @since 0.2.0
  class SubitoArgParser
   
    # Parse the command line option 
    #
    # @param [Array] ARGV
    def self.parse(args)
      options = {
        :language => "en", 
        :complete_language => "english",
        :create_database =>false, 
        :working_directory => ".", 
        :name => "*.{avi,mp4,mkv}", 
        :to_rename => true,
        :as_if =>{},
        :v => false
      }

      languages = SConfig.instance.data["language"]

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: subito [options] "
        opts.separator ""
        opts.separator "Specific options:"
        opts.on("-l","--language LANGUAGE", languages.keys, "Download the LANGUAGE version of the subtitle file, option are #{languages}") do |lang|
          options[:language] = lang
          options[:complete_language] = languages[lang]
        end
        opts.separator ""
        opts.on("-d","--create-database", "Create or update show database") do |db|
          options[:create_database] = db
        end
        opts.on("-w","--directory DIR","Run in directory DIR") do |dir| 
          options[:working_directory] = dir
        end
        opts.on("-n","--name PATTERN","Run for all show matching the pattern PATTERN") do |raw_name| 
          options[:name] = raw_name
        end
        opts.on("--[no-]renaming", "Rename the subtitle file as the raw name (default)") do |t| 
          options[:to_rename] = t
        end
        opts.on("--replace oldname,newname", Array, "Run the application considering the name 'oldname' of the show is now 'newname'. If there is any whitespace in oldname and/or newname, surround with quotation marks  ") do |array|
          array[1] ||= array[0]
          options[:as_if] = {array[0] => array[1]}
        end
        opts.separator ""
        opts.on("-v","--verbose", "if enabled, display more accurate information") do |v|
          options[:v] = v
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
