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
    assert_equal(4, PomodoroCountByDay.find_all[0].count)
  end
  
  def test_adding_pomodoros_to_the_count
    @pcbd << "pomodoro"
    @pcbd << "pomodoro"
    assert_equal(2, @pcbd.count)
  end
  
  def test_should_order_by_date
    counts = PomodoroCountByDay.find_all
    assert(counts[0].date < counts[1].date, "First count should be before of second")
    assert(counts[1].date < counts[2].date)
  end
  
end
