require File.dirname(__FILE__) + '/pomodori'
require 'pomodori/application'
require 'pomodori/kirby_storage'

KirbyStorage.init_db
Application.new.start