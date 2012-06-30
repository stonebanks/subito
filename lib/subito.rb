module Subito
  VERSION = "0.2.0"
  ROOT = File.expand_path(File.dirname(__FILE__))
  Dir.glob(File.join(ROOT, "subito",'*.rb')).each  do |file|
    require file
  end
end
