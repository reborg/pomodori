require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/countdown'

class CountdownTest < Test::Unit::TestCase
  
  def setup
    @ctdown = Countdown.new(60*25)
  end
  
  def test_should_tell_minutes
    assert_equal(25, @ctdown.mins)
  end
  
  def test_should_tell_seconds
    assert_equal(0, @ctdown.secs)
  end
  
  def test_should_decrease_a_second
    @ctdown.tick
    assert_equal(24, @ctdown.mins)
    assert_equal(59, @ctdown.secs)
  end
  
  def test_just_stop_to_zero
    @ctdown = Countdown.new(1)
    @ctdown.tick
    assert_equal(0, @ctdown.mins)
    assert_equal(0, @ctdown.secs)
  end
    
end

class CountdownCallbackTest < Test::Unit::TestCase
  
  def test_receives_the_callback_at_new
    ctdown = Countdown.new(2, lambda {})
    assert_not_nil(ctdown.callback)
  end
  
  def test_callback_on_zero
    called = false
    ctdown = Countdown.new(1, lambda {called = true})
    ctdown.tick
    assert(called)
  end
  
end
