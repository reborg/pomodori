require 'rubygems'
Dir.glob(File.join(File.dirname(__FILE__), 'pomodori/**/*_test.rb')).each {|f| require f}
