require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/main_view'

class SummaryLabelTest < Test::Unit::TestCase

  def setup
    controller = stub(:yesterday_pomodoros => 10, :today_pomodoros => 5)
    @main_view = MainView.new(:pomodori_controller => controller)
  end

  def test_shows_statistics_for_break
    @main_view.break_mode
    assert_match(/BREAK/, @main_view.summary_label.to_s)
    assert_match(/10/, @main_view.summary_label.to_s)
    assert_match(/5/, @main_view.summary_label.to_s)
  end

  def test_label_shows_statistics_for_pomodoro
    @main_view.running_mode
    assert_match(/POMODORO/, @main_view.summary_label.to_s)
    assert_match(/10/, @main_view.summary_label.to_s)
    assert_match(/5/, @main_view.summary_label.to_s)
  end
  
end