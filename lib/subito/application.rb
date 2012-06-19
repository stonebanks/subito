$:.unshift File.join(File.dirname(__FILE__), '..')

require 'subito/yml_database'
module Subito
  class Application
    def self.run(options)
      p options
      #build database
      if options[:create_database]
        puts "Creating database..."
        Dir.chdir(Dir.home){YamlDatabase.instance.write }
      end
      
      Dir.chdir(options[:working_directory]) do 
        
      end
    end
  end
end
