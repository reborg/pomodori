require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/chart_view'
require 'hotcocoa'

class ChartViewTest < Test::Unit::TestCase
  
  def setup
    @charts_controller = mock
    @chart_view = ChartView.new(:charts_controller => @charts_controller)
  end
  
  it "should load url" do
    @chart_view.send(:hc_web_view).expects(:url=).with("/temp/some.html")
    @chart_view.load_chart("/temp/some.html")
  end
  
  it "should add webview on top" do
    assert_equal(1, @chart_view.send(:hc_top_view).subviews.size)
    assert_kind_of(WebView, @chart_view.send(:hc_top_view).subviews[0])
  end
  
  it "should add 2 buttons bottom" do
    assert_equal(2, @chart_view.send(:hc_bottom_view).subviews.size)
  end
  
  it "delegates to ctrl on reload" do
    @charts_controller.expects(:on_reload_chart)
    @chart_view.send(:reload_button_action).call("sender")
  end

  it 'closes the window on close button' do
    hc_chart_window = mock()
    @chart_view.expects(:hc_chart_window).returns(hc_chart_window)
    hc_chart_window.expects(:close)
    @chart_view.send(:close_window_action).call("me")
  end

end
