require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/application'
require 'pomodori/pomodori_controller'

class OnSubmitTest < Test::Unit::TestCase

  def setup
    @application = Application.new
    @pomodori_controller = mock
    PomodoriController.expects(:new).at_most_once.returns(@pomodori_controller)
  end
  
  def test_should_lazy_initialize_controller
    @application.pomodori_controller
    @application.pomodori_controller
  end
  
  def test_create_on_click
    @pomodori_controller.expects(:create)
    @application.on_click_submit_button.call
  end
  
  def test_create_on_click
    @pomodori_controller.expects(:create)
    countdown_field = mock
    @application.expects(:countdown_field).returns(countdown_field)
    countdown_field.expects(:start).with(60*5, @application.method(:on_5_mins_done))
    @application.on_click_submit_button.call
  end
  
  def test_description_should_clean_up_after_submission
    @pomodori_controller.expects(:create)
    @application.input_box.render.text = "hola"
    @application.on_click_submit_button.call
    assert_equal("", @application.input_box.render.to_s)
  end
  
  def test_starts_another_25_mins_timer
    countdown_field = mock
    @application.expects(:countdown_field).returns(countdown_field)
    countdown_field.expects(:start).with(60*25)
    @application.on_5_mins_done
  end
  
end