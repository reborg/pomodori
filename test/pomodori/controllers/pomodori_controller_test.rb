require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/models/pomodoro'
require 'pomodori/kirby_storage'
require 'pomodori/controllers/pomodori_controller'

class PomodoriControllerTest < Test::Unit::TestCase
  
  def setup
    @main_view = mock('main_view')
    @pomodori_controller = PomodoriController.new(:main_view => @main_view)
    @storage = stub_everything
    @pomodori_controller.stubs(:storage => @storage)
  end
  
  it "should create a new pomodoro" do
    storage = mock('storage')
    ctrl = PomodoriController.new
    ctrl.storage = storage
    storage.expects(:save)
    ctrl.create({:text => "hola"})
  end
  
  it "should not fail when no pomodoros exist" do
    PomodoroCountByDay.stubs(:find_all).returns([])
    assert_nothing_raised { @pomodori_controller.daily_average }
  end
  
  it "should return the average daily pomo" do
    PomodoroCountByDay.stubs(:find_all).returns(pomodoro_count_by_day_sample)
    @pomodori_controller.daily_average.should == 1
  end
  
  it "retrieves yesterday's pomodoros" do
    @storage.expects(:find_all_day_before).returns([])
    @pomodori_controller.yesterday_pomodoros
  end
  
  it "retrieves today's pomodoros" do
    @storage.expects(:find_all_by_date).returns([])
    @pomodori_controller.today_pomodoros
   end
  
end
