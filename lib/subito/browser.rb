require 'mechanize'
require 'singleton'
require 'subito/exception'
require 'subito/verbose'

module Subito
  # This class wraps some mechanize routine
  #
  # @since 0.2.0
  class Browser
    include Singleton
    attr_reader :agent
    # Constructor
    def initialize
      @agent = Mechanize.new
    end

    # Connect to a page at the given url
    #
    # @param [String] url the complement of the web page root
    # @return [Mechanize::Page] an html page
    def get(url)
      verbose = Verbose.instance
      begin
        ret = @agent.get(url, [], url)
        verbose.msg "Connection has succeeded", :debug
        yield(ret) if block_given?
        ret
      rescue Mechanize::Error
        verbose.msg "Connection error", :error
        raise WebSiteNotReachableError
      end
    end
  end
end

