require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/application'

class OnClickTheSubmitButtonTest < Test::Unit::TestCase

  def setup
    @application = Application.new
    @application.stubs(:update_metrics_for_break)
  end

  def test_it_starts_the_break
    countdown_field = mock('countdown_field')
    @application.expects(:countdown_field).returns(countdown_field)
    countdown_field.expects(:start).with(Application::BREAK, @application.method(:on_5_mins_done))
    @application.on_click_submit_button.call
  end
  
  def test_creates_a_pomodoro
    controller = mock('controller')
    @application.expects(:pomodori_controller).returns(controller)
    controller.expects(:create)
    @application.on_click_submit_button.call
  end
  
end