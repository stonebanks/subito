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
          puts s
        end
      end
    end
  end
end
