require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/models/pomodoros_by_tag'
require 'pomodori/models/pomodoro'

class PomodorosByTagTest < Test::Unit::TestCase
  
  def setup
    @pbt = PomodorosByTag.new
  end
  
  def test_should_be_zero
    actual = @pbt.count('tag')
    assert_equal(0, actual)
  end
  
  def test_should_increment_count
    actual = @pbt.count('tag')
    @pbt.add(Pomodoro.new(:text => '@tag something'))
    @pbt.add(Pomodoro.new(:text => '@tag something'))
    assert_equal(2, @pbt.count('tag') - actual)
  end
  
  def test_should_increment_for_multiple_tags
    @pbt.add(Pomodoro.new(:text => '@tag @something hello'))
    assert_equal(@pbt.count('tag'), @pbt.count('something'))    
  end
  
end