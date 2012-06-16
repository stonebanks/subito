$:.unshift File.join(File.dirname(__FILE__), '..')
module Subito

  class ShowFeature
    attr_accessor :id, :raw_name, :name, :team, :episode, :season
    PATTERN = /(^[\w\.\(\)]+)\.(\d{3}|s?\d{1,2}[ex]?\d{2})\..*-(.*)\.[\d\w]{3}$/i
 
    def parse_show(str)
      raw_name = str
      @name = str[PATTERN, 1].nil? ? nil : str[PATTERN, 1].downcase.tr_s('.',' ')
      @season = str[PATTERN,2].nil? ? nil : "%02d" % str[PATTERN,2][/(\d+).?(\d{2}$)/,1]
      @episode = str[PATTERN,2].nil? ? nil : "%02d" % str[PATTERN,2][/(\d+).?(\d{2}$)/,2]
      @team = str[PATTERN,3].nil? ? nil : str[PATTERN,3].downcase
    end

    def get_id
    end
  end
end
