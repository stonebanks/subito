$:.unshift File.join(File.dirname(__FILE__), '..')
require 'erb'
require 'yaml'
require 'singleton'

module Subito
  class SConfig
    include Singleton
    attr_reader :data
    def initialize
      @data = YAML::load_file(File.join(File.dirname(__FILE__),'..', 'config.yml'))
      self.data.keys.each do |key|
        define_methods(key, self.data[key].keys)
      end
    end


    def define_methods(prefix_name, names)
      names.each do |name|
        function = prefix_name+"_"+name
        self.class.class_eval <<-EOS
         def #{function}
           self.data["#{prefix_name}"]["#{name}"]
         end
        EOS
      end
    end
  end
end
