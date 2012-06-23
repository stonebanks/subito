$:.unshift File.join(File.dirname(__FILE__), '..')
require 'subito/yml_database'
module Subito

  class ShowFeature
    attr_accessor :id, :raw_name, :name, :team, :episode, :season
    PATTERN = /(^[\w\.\(\)]+)\.(\d{3}|s?\d{1,2}[ex]?\d{2})\..*-(.*)\.[\d\w]{3}$/i
 
    def parse_show(str)
      @name = str[PATTERN, 1].nil? ? nil : str[PATTERN, 1].downcase.tr_s('.',' ')
      @season = str[PATTERN,2].nil? ? nil : "%02d" % str[PATTERN,2][/(\d+).?(\d{2}$)/,1].to_i
      @episode = str[PATTERN,2].nil? ? nil : "%02d" % str[PATTERN,2][/(\d+).?(\d{2}$)/,2].to_i
      @team = str[PATTERN,3].nil? ? nil : str[PATTERN,3].downcase
      @id = get_id(@name)
    end

    def get_id(name)
      nil
      YamlDatabase.instance.get(name) unless name.nil?
    end

    def dyn_replace
      
    end
    
    def to_s
      "name : #{name} season: #{season} episode: #{episode} team: #{team} id: #{id}"
    end
  end
end
