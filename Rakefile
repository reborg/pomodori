require 'hotcocoa/application_builder'
require 'hotcocoa/standard_rake_tasks'

task :default => [:test]

task :test do
  require 'open3'
	Open3.popen3('macruby test/all_tests.rb') { |stdin, stdout, stderr| puts stdout.read }
end