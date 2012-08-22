require 'rake/testtask'
#require "bundler/setup"

task :default => [:test]

Rake::TestTask.new do |test|
test.libs << "test"
test.test_files = Dir[ "test/*test*.rb" ]
test.verbose = true
end

