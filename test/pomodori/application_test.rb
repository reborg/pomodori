require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/application'
require 'pomodori/pomodori_controller'

class OnSubmitTest < Test::Unit::TestCase

  def setup
    @application = Application.new
  end

  # def test_change_label_to_break_after_submission
  #   @application.on_click_submit_button.call
  #   assert_equal("   ...break", @application.input_box.render.to_s)
  # end
  # 
  # def test_changes_button_after_submit
  #   @application.on_click_submit_button.call
  #   assert_equal("Stop", @application.submit_button.render.title)
  # end

  
  def test_it_starts_the_break_after_submit
    countdown_field = mock('countdown_field')
    @application.expects(:countdown_field).returns(countdown_field)
    countdown_field.expects(:start).with(Application::BREAK, @application.method(:on_5_mins_done))
    @application.on_click_submit_button.call
  end
  
  def test_create_on_click
    controller = mock('controller')
    @application.expects(:pomodori_controller).returns(controller)
    controller.expects(:create)
    @application.on_click_submit_button.call
  end
  
  def test_starts_another_25_mins_timer_after_break
    countdown_field = mock('countdown_field')
    @application.expects(:countdown_field).returns(countdown_field)
    countdown_field.expects(:start)
    @application.on_5_mins_done
  end
  
  def test_disable_input_box_after_break
    text_input = mock('text_input')
    @application.expects(:input_box).returns(text_input)
    text_input.expects(:disable)
    @application.on_5_mins_done
  end
  
  def test_rings_after_25_mins
    @application.expects(:ring)
    @application.on_25_mins_done
  end
  
  def test_enables_text_input_after_25_mins
    text_input = mock('text_input')
    @application.expects(:input_box).returns(text_input)
    text_input.expects(:enable)
    @application.on_25_mins_done
  end
  
  def test_changes_button_label_to_submit_after_25_mins
    button = mock('button')
    @application.expects(:submit_button).returns(button)
    button.expects(:label=).with("Submit")
    @application.on_25_mins_done
  end
  
  def test_should_play_sound
    sound = mock('sound')
    @application.expects(:sound).returns(sound)
    sound.expects(:play)
    @application.ring
  end
   
end