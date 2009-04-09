require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/models/pomodoro'
require 'pomodori/kirby_storage'
require 'pomodori/controllers/pomodori_controller'

class PomodoriControllerTest < Test::Unit::TestCase
  
  def setup
    @main_view = mock('main_view')
    @pomodori_controller = PomodoriController.new(:main_view => @main_view)
  end
  
  def test_create_new_pomodoro
    storage = mock('storage')
    ctrl = PomodoriController.new
    ctrl.storage = storage
    storage.expects(:save)
    ctrl.create({:text => "hola"})
  end
  
end
