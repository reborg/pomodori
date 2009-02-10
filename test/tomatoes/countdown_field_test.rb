require File.dirname(__FILE__) + '/../test_helper'
require 'tomatoes/countdown_field'
require 'tomatoes/countdown'

class CountdownFieldTest < Test::Unit::TestCase
  
  def setup
    @countdown_field = CountdownField.new(:countdown => 1)
  end
  
  def test_should_format_time
    assert_equal("00:01", @countdown_field.time)
    @countdown_field.countdown = Countdown.new(60)
    assert_equal("01:00", @countdown_field.time)
    @countdown_field.countdown = Countdown.new( (60*25) -1 )
    assert_equal("24:59", @countdown_field.time)
  end
  
  def test_initializes_on_25_mins
    assert_equal("25:00", CountdownField.new.time)
  end
  
  def test_renders_as_cocoa_object
    @countdown_field.render
    assert_not_nil(@countdown_field.render)
  end
  
end

class CountdownFieldTimerTest < Test::Unit::TestCase
  
  def setup
    @countdown_field = CountdownField.new
  end
  
  def test_timer_should_start
    assert_not_nil(@countdown_field.start_time)
  end
  
  def test_should_update_text_on_tick
    @countdown_field.send(:on_timer_tick)    
    assert_equal("24:59", @countdown_field.render.to_s)
  end
  
  def test_prints_done_when_done
    @countdown_field = CountdownField.new(:countdown => 1)
    @countdown_field.send(:on_timer_tick)
    assert_equal("Done!", @countdown_field.render.to_s)
  end
  
end

