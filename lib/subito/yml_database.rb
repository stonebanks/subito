$:.unshift File.join(File.dirname(__FILE__), '..')

require 'yaml'
require 'singleton'
require 'amatch'
require 'subito'
include Amatch
module Subito
  # This class contains methods used for the access of the yaml database
  #
  # @since 0.2.0
  class YamlDatabase
    include Singleton
    # attr_reader
    attr_reader :filename
    # attr_accessor
    attr_accessor :dictionnary
    # Constructor
    def initialize(filename = '.subito.store')
      @filename, @dictionnary = filename, {}
    end

    # Write the tv shows database, elements in the base are name_of_show => id
    def write
      Verbose.instance.msg "Connecting to #{SConfig.instance.ressources_subsite_name}", :debug
      page = Browser.instance.get SConfig.instance.ressources_subsite_name
      Verbose.instance.msg "Parsing the page", :debug
      nodeset = page.parser.xpath SConfig.instance.yaml_database_data_xpath
      nodeset.each do |node|
        @dictionnary[node.text.downcase] = node.attr('value')
      end
      Verbose.instance.msg "Creating Database file in $HOME/#{self.filename}", :debug
      Dir.chdir Dir.home do 
        File.open(self.filename, 'w') do |out|
          YAML.dump(@dictionnary, out)
        end      
      end
     end

    # Return the id of the show for the given name
    #
    # @param [String] name the name of the tv show
    # @return [String] the corresponding id
    def get(name)
      if self.dictionnary.empty?
        absolute_filename = File.join(Dir.home, @filename)
        unless File.exists? absolute_filename
          Verbose.instance.msg "#{absolute_filename} does not exist, It needed to be created", :debug
          write
        end
        Verbose.instance.msg "Loading Database...", :debug
        self.dictionnary = YAML.load_file absolute_filename
      end
      self.dictionnary[name]
    end

    def get_all_shows_similar_to(str, threshold =0.7, method = JaroWinkler)
     m =  method.new(str)
      @dictionnary.select do |k,v| 
        m.similar(k) >= threshold
      end
    end
  end
end
