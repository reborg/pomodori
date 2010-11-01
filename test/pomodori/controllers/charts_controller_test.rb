require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/controllers/charts_controller'
require 'pomodori/models/chart'

class ChartsControllerTest < Test::Unit::TestCase
  
  def setup
    @chart = mock(:process => "/tmp/something.html")
    Chart.stubs(:new).returns(@chart)
    @chart_view = mock
    @charts_controller = ChartsController.new(:chart_view => @chart_view)
  end
  
  def test_should_load_default_chart_on_load_view
    @chart_view.expects(:load_chart).with("/tmp/something.html")
    @charts_controller.on_load_view
  end
  
  def test_should_tell_the_view_to_reload_url
    test_should_load_default_chart_on_load_view
  end
    
end
