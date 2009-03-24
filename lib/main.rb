require File.dirname(__FILE__) + '/pomodori'
require 'pomodori/kirby_storage'
require 'pomodori/views/main_view'

KirbyStorage.init_db

require 'hotcocoa'
include HotCocoa
application do |app| 
  MainView.new.render.will_close {exit}
end
