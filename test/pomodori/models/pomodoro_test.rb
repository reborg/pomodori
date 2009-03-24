require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/models/pomodoro'

class PomodoroTest < Test::Unit::TestCase
  
  def setup
    @pomodoro = Pomodoro.new
  end
  
  def test_intializes_with_arg_hash
    now = DateTime.now
    pomodoro = Pomodoro.new({:text => "hola", :timestamp => now})
    assert_equal("hola", pomodoro.text)
    assert_equal(now, pomodoro.timestamp)
  end
  
  def test_has_default_timestamp
    assert_not_nil(@pomodoro.timestamp)
  end
  
end
