require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/pomodori_controller'
require 'pomodori/pomodoro'
require 'pomodori/kirby_storage'

class PomodoriControllerTest < Test::Unit::TestCase
  
  def setup
    @pomodoro = mock
    @storage = mock
    @ctrl = PomodoriController.new
  end
  
  def test_create_new_pomodoro
    Pomodoro.expects(:new).with(:text => "hola").returns(@pomodoro)
    KirbyStorage.expects(:new).returns(@storage)
    @storage.expects(:save)
    @ctrl.create({:text => "hola"})
  end
  
end
