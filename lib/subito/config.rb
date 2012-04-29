require 'erb'
require 'yaml'
require 'singleton'

module Subito
  class Config
    include Singleton
    attr_reader :data
    def initialize
      @data = YAML::load_file(File.join(File.dirname(__FILE__),'..', 'config.yml'))
      define_methods(data['ressources'].keys)
    end


    def define_methods(names)
      names.each do |name|
        self.class.class_eval <<-EOS
         def #{name}
           data['ressources']["#{name}"]
         end
        EOS
      end
    end
  end
end
