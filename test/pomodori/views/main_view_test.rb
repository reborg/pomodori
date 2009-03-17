require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/main_view'

class MainViewTest < Test::Unit::TestCase
  
  def setup
    @main_view = MainView.new
  end
  
  def test_one_label_bottom_left
    assert(true)
  end
  
end