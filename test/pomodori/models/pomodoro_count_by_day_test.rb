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
  
end
