require 'mechanize'
require 'singleton'


module Subito
   
  class Browser
    include Singleton
    attr_reader :agent
    def initialize
      @agent = Mechanize.new
    end
  end

end
