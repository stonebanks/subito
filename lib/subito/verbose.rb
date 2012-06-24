$:.unshift File.join(File.dirname(__FILE__), '..')
require 'logger'
require 'singleton'

class <<Singleton
  def included_with_reset(klass)
    included_without_reset(klass)
    class <<klass
      def reset_instance
        Singleton.send :__init__, self
        self
      end
    end
  end
  alias_method :included_without_reset, :included
  alias_method :included, :included_with_reset
end

module Subito 
  class Verbose
    include Singleton
    @@enable
    @@io
    @@logger
    DISPLAY_SETTINGS = [:default, :none]
    def initialize()
      @enable, @io, @logger = @@enable, @@io, @@logger
    end
    def self.enable=(enable)
      @@enable = enable
    end
    def self.io=(io)
      @@io = io
    end 
    def self.io
      @@io
    end
    def self.logger=(logger)
      @@logger = logger
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

