require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/models/pomodoro'
require 'pomodori/kirby_storage'
require 'pomodori/pomodori_controller'

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
  
  def test_void_current_pomodoro
    @main_view.expects(:now_counting=).with('Break')
    @main_view.expects(:timer=).with(5*60)
    @main_view.expects(:modal_button=).with('Restart')
    @pomodori_controller.void_pomodoro
  end
  
end
