require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/application'

class On25MinsTimerTest < Test::Unit::TestCase

  def setup
    @application = Application.new
  end

  def test_rings
    @application.expects(:ring)
    @application.on_25_mins_done
  end
  
  def test_enables_text_input
    text_input = mock('text_input')
    @application.expects(:input_box).returns(text_input)
    text_input.expects(:enable)
    @application.on_25_mins_done
  end
  
  def test_changes_button_label_and_action
    button = mock('button')
    @application.expects(:submit_button).at_least(2).returns(button)
    button.expects(:label=).with("Submit")
    button.expects(:action=)
    @application.on_25_mins_done
  end
  
end