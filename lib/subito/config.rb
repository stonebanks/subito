$:.unshift File.join(File.dirname(__FILE__), '..')
require 'erb'
require 'yaml'
require 'singleton'

module Subito
  class Config
    include Singleton
    attr_reader :data
    def initialize
      @data = YAML::load_file(File.join(File.dirname(__FILE__),'..', 'config.yml'))
      data.keys.each do |key|
        define_methods(key, data[key].keys)
      end
    end


    def define_methods(prefix_name, names)
      names.each do |name|
        self.class.class_eval <<-EOS
         def #{prefix_name}_#{name}
           data["#{prefix_name}"]["#{name}"]
         end
        EOS
      end
    end
  end
end
