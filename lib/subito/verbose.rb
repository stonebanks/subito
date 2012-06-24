$:.unshift File.join(File.dirname(__FILE__), '..')
require 'logger'
require 'singleton'


module Subito 
  # This class is used to output useful informations about the application running 
  #
  # @since 0.2.0
  class Verbose
    include Singleton
    #attr_accessor
    attr_accessor :enable, :io, :logger
    
    # Set the attributes of the class
    #
    # @param [Boolean] enable whether verbose mode is enabled (false by default)
    # @param [IO] io the simplest media where log will be printed if verbose mode is disabled
    def set(enable, io)
      @enabled, @io, @logger = enable, io, Logger.new(io)
    end
    
    # Display a message in a IO
    # outputs a message if message has to be display by default
    # or if Verbose#enable is true in that case  use Logger
    # @param [String] message the message to display
    # @param [Symbol] setting value are :default and all value levels of Logger
    #                 if :default the method only puts the simplest messages in IO
    #                 else all messages are puts in IO and are formatted like using Logger
    def msg(message, setting = :default)
      nil
      @io.puts(message) if not(@enabled) and setting.eql? :default
      @logger.send(setting.eql?(:default)? :info : setting , message)if @enabled
    end
  end
end

