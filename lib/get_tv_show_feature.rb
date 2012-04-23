require 'exception_raiser'
require 'constant'
require 'my_utils'

include ExceptionRaiser
include Constant
module Subito
  module TVShowFeature
    extend self
    PATTERN = /(^[\w\.]+)\.(\d{3}|s?\d{1,2}[ex]?\d{2})\./i
    
    def parse_show(str)
      raise_if_bad_type str, String
      output = {}
      output = {:raw_name => str,
        :name => name(str),
        :season => season(str),
        :episode => episode(str),
        :acquisition => acquisition(str),
        :team => team(str),
        :is720p => (str['720p']? true : false)} if File.extname(str).eql? '.avi'
      output
    end

    def name(str)
      begin
        out = str[PATTERN, 1].downcase.tr_s('.',' ')
      rescue NoMethodError
        nil
      end
    end
    
    def season(str)
      begin
        "%02d" % str[PATTERN,2][/(\d+).?(\d{2}$)/,1]
      rescue NoMethodError
        nil
      end
    end

    def episode(str)
      begin
        "%02d" % str[PATTERN,2][/(\d+).?(\d{2}$)/,2]
      rescue NoMethodError
        nil
      end
    end

    def acquisition(str)
      begin
        str[MyUtils.create_regexp(ACQUISITION)].downcase
      rescue NoMethodError
        nil
      end
    end
    
    def team(str)
      begin
        str[MyUtils.create_regexp(TEAM)].downcase
      rescue NoMethodError
        nil
      end
    end

  end
end

