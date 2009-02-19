require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/application'

class DisplayStatisticsTest < Test::Unit::TestCase

  def setup
    @application = Application.new
    controller = mock('controller')
    @application.expects(:pomodori_controller).at_least(1).returns(controller)
    controller.stubs(:yesterday_pomodoros).returns(10)
    controller.stubs(:today_pomodoros).returns(5)
  end

  def test_changes_button_label_for_break
    @application.update_metrics_for_break
    assert_equal("Stop", @application.submit_button.title)
  end
  
  def test_label_shows_statistics_for_break
    @application.update_metrics_for_break
    assert_match(/BREAK/, @application.input_box.render.to_s)
    assert_match(/10/, @application.input_box.render.to_s)
    assert_match(/5/, @application.input_box.render.to_s)
  end  

  def test_changes_button_label_for_pomodoro
    @application.update_metrics_for_pomodoro
    assert_equal("Void", @application.submit_button.title)
  end
  
  def test_label_shows_statistics_for_pomodoro
    @application.update_metrics_for_pomodoro
    assert_match(/POMODORO/, @application.input_box.render.to_s)
    assert_match(/10/, @application.input_box.render.to_s)
    assert_match(/5/, @application.input_box.render.to_s)
  end  
  
end