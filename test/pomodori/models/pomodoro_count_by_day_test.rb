require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/models/pomodoro_count_by_day'
require 'pomodori/kirby_storage'

class PomodoroCountByDayTest < Test::Unit::TestCase
  
  def setup
    @pcbd = PomodoroCountByDay.new(DateTime.now)
    @kirby_storage = stub(:find_all => pomodoros)
    KirbyStorage.stubs(:new).returns(@kirby_storage)
  end

  def test_should_group_by_day
    assert_equal(3, PomodoroCountByDay.find_all[0].count)
  end
  
  def test_adding_pomodoros_to_the_count
    @pcbd << "pomodoro"
    @pcbd << "pomodoro"
    assert_equal(2, @pcbd.count)
  end
  
  it "should tell me who comes first" do
    another = PomodoroCountByDay.new(DateTime.now)
    another <=> @pcbd
  end
  
  
  it "compares to another PomoCount" do
    PomodoroCountByDay.include?(Comparable).should be(true)
    (@pcbd > PomodoroCountByDay.new(DateTime.new(2008))).should be(true)
    (@pcbd > PomodoroCountByDay.new(DateTime.new(2010))).should be(false)
  end
  
  it "orders pomo count most recent first" do
    counts = PomodoroCountByDay.find_all
    assert(counts[0].date > counts[1].date, "First pomo count date should be the most recent")
    assert(counts[1].date > counts[2].date, "Second pomo count date should be before next one")
  end
  
end
