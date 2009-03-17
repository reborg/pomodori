require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/main_view'

class MainViewTest < Test::Unit::TestCase
  
  def setup
    @main_view = MainView.new
  end
  
  def test_2_buttons_at_bottom_right
    assert_equal(2, @main_view.bottom_right_view.subviews.size)
    @main_view.bottom_right_view.subviews.each {|subview| assert_match(/Button/, subview.class.to_s)}
  end
  
  def test_one_label_bottom_left
    assert_equal(1, @main_view.bottom_left_view.subviews.size)
    assert_match(/TextField/, @main_view.bottom_left_view.subviews[0].class.to_s)
  end
  
  def test_top_left_view
    assert_equal(1, @main_view.top_left_view.subviews.size)
    assert_match(/TextField/, @main_view.top_left_view.subviews[0].class.to_s)
  end
  
  def test_top_right_view
    assert_equal(1, @main_view.top_right_view.subviews.size)
    assert_match(/ImageView/, @main_view.top_right_view.subviews[0].class.to_s)
  end
  
end