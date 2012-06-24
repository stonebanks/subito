$:.unshift File.join(File.dirname(__FILE__), '..')
require 'logger'
require 'singleton'
module Subito 
  class Verbose
    attr_accessor :enable, :io, :logger

    DISPLAY_SETTINGS = [:default, :none]
    def initialize(enable, io = $stdout, logger = Logger.new($stdout))
      @enable, @io, @logger = enable, io, logger
    end

    # outputs a message if message has to be display by default
    # or if Verbose#enable is true in that case  use Logger
    def msg(message, setting = :none)
      nil
      @io.puts(message) if setting.eql? :default
      unless setting.eql? :default or setting.eql? :none
        @logger.send(setting, message)
      end
    end
  end
end

