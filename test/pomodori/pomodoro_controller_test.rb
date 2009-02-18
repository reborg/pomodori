require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/pomodoro'
require 'pomodori/kirby_storage'
require 'pomodori/pomodori_controller'

class PomodoriControllerTest < Test::Unit::TestCase
  
  def test_create_new_pomodoro
    storage = mock('storage')
    ctrl = PomodoriController.new
    ctrl.storage = storage
    storage.expects(:save)
    ctrl.create({:text => "hola"})
  end
  
end
