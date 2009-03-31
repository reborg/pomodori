require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/chart_view'
require 'hotcocoa'

class ChartViewTest < Test::Unit::TestCase
  
  def setup
    @charts_controller = mock
    @chart_view = ChartView.new(:charts_controller => @charts_controller)
  end
  
  def test_should_load_url
    @chart_view.browser.expects(:url=).with("/temp/some.html")
    @chart_view.load_chart("/temp/some.html")
  end
  
  def test_should_add_webview_on_top
    assert_equal(1, @chart_view.top_view.subviews.size)
    assert_kind_of(WebView, @chart_view.top_view.subviews[0])
  end
  
  def test_should_add_2_buttons_bottom
    assert_equal(2, @chart_view.bottom_view.subviews.size)
  end
  
end