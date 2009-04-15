require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/models/pomodoro'
require 'pomodori/kirby_storage'
require 'pomodori/controllers/pomodori_controller'

class PomodoriControllerTest < Test::Unit::TestCase
  
  def setup
    @main_view = mock('main_view')
    @pomodori_controller = PomodoriController.new(:main_view => @main_view)
  end
  
  it "should create a new pomodoro" do
    storage = mock('storage')
    ctrl = PomodoriController.new
    ctrl.storage = storage
    storage.expects(:save)
    ctrl.create({:text => "hola"})
  end
  
  it "should return the average daily pomo" do
    PomodoroCountByDay.stubs(:find_all).returns(pomodoro_count_by_day_sample)
    @pomodori_controller.daily_average.should == 1
  end

end
