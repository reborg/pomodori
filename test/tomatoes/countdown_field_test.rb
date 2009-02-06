require File.dirname(__FILE__) + '/../test_helper'
require 'tomatoes/countdown_field'
require 'tomatoes/countdown'

class CountdownFieldTest < Test::Unit::TestCase
  
  def setup
    @countdown = Countdown.new(1)
    @countdown_field = CountdownField.new(:countdown => @countdown)
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
  
  def test_forwards_the_tick
    @countdown_field.render
    @countdown.expects(:tick)
    @countdown_field.tick
  end
  
end
