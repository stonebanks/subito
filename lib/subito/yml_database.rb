$:.unshift File.join(File.dirname(__FILE__), '..')

require 'yaml'
require 'singleton'
require 'amatch'
require 'subito/browser'
require 'subito/config'

include Amatch
module Subito
  class YamlDatabase
    include Singleton
    attr_reader :filename
    attr_writer :hash
    def initialize(filename = '.subito.store')
      @filename = filename
      @hash = {}
    end

    def write
      page = Browser.instance.get SConfig.instance.ressources_subsite_name
      nodeset = page.parser.xpath SConfig.instance.yaml_database_data_xpath
      nodeset.each do |node|
        @hash[node.text] = node.attr('value')
      end
      Dir.chdir Dir.home do 
        File.open(self.filename, 'w') do |out|
          YAML.dump(@hash, out)
        end      
      end
     end

    #return the id of the show name
    def get(name)
      if self.hash.empty?
        absolute_filename = File.join(Dir.home, self.filename)
        write unless File.exists? absolute_filename
        self.hash = YAML.load_file absolute_filename
      end
      self.hash[name]
    end

    def get_all_shows_similar_to(str, threshold =0.7, method = JaroWinkler)
     m =  method.new(str)
      @hash.select do |k,v| 
        m.similar(k) >= threshold
      end
    end
  end
end
