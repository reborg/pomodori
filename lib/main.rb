require File.dirname(__FILE__) + '/tomatoes'
require 'tomatoes/application'
require 'tomatoes/kirby_storage'

KirbyStorage.init_db
Application.new.start