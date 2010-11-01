require File.dirname(__FILE__) + "/../vendor/hotcocoa-0.5.1+patch/lib/hotcocoa"
include HotCocoa
require File.dirname(__FILE__) + '/../lib/pomodori'
Dir.glob(File.join(File.dirname(__FILE__), '../lib/pomodori/**/*.rb')).each {|f| require f}
