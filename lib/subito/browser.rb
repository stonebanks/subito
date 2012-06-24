require 'mechanize'
require 'singleton'
require 'subito/exception'

module Subito
   
  class Browser
    include Singleton
    attr_reader :agent
    def initialize
      @agent = Mechanize.new
    end

    def get(url)
      begin
        ret = @agent.get(url, [], url)
        yield(ret) if block_given?
        ret
      rescue Mechanize::Error
        raise WebSiteNotReachableError
      end
    end
  end
end

