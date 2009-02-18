require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/application'
require 'pomodori/pomodori_controller'

class ApplicationTest < Test::Unit::TestCase

  def setup
    @application = Application.new
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
  
  def test_should_play_sound
    sound = mock('sound')
    @application.expects(:sound).returns(sound)
    sound.expects(:play)
    @application.ring
  end
   
end