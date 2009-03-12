require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'
Dir.glob(File.join(File.dirname(__FILE__), 'pomodori/**/*_test.rb')).each {|f| require f}