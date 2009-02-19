require 'hotcocoa'
include HotCocoa
require File.dirname(__FILE__) + '/../lib/pomodori'
Dir.glob(File.join(File.dirname(__FILE__), '../lib/pomodori/**/*.rb')).each {|f| require f}
