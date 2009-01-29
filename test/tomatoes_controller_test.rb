require File.dirname(__FILE__) + '/test_helper'

class TomatoesControllerTest < Test::Unit::TestCase
  
  def setup
    @tomato = mock
    @storage = mock
    @ctrl = TomatoesController.new
  end
  
  def test_create_new_tomato
    Tomato.expects(:new).with(:text => "hola").returns(@tomato)
    Storage.expects(:new).returns(@storage)
    @storage.expects(:save)
    @ctrl.create({:text => "hola"})
  end
  
end
