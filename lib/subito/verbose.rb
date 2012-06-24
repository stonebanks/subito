$:.unshift File.join(File.dirname(__FILE__), '..')
require 'logger'
require 'singleton'


module Subito 
  class Verbose
    include Singleton
    attr_accessor :enable, :io, :logger
    
    def set(enable, io, logger)
      @enabled, @io, @logger = enable, io, logger
    end
    # outputs a message if message has to be display by default
    # or if Verbose#enable is true in that case  use Logger
    def msg(message, setting = :default)
      nil
      @io.puts(message) if not(@enabled) and setting.eql? :default
      @logger.send(setting.eql?(:default)? :info : setting , message)if @enabled
    end
  end
end

