require File.dirname(__FILE__) + "/../vendor/hotcocoa-0.5.1+patch/lib/hotcocoa"
require File.dirname(__FILE__) + '/pomodori'
require 'pomodori/migration'
require 'pomodori/views/main_view'

Migration.init_db

include HotCocoa
application do |app|
  main_view = MainView.new
  main_view.render.will_close {exit}
  main_view.running_mode
end
