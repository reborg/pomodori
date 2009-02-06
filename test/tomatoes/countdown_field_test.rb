require File.dirname(__FILE__) + '/../test_helper'
require 'tomatoes/countdown_field'
require 'tomatoes/countdown'

class CountdownFieldTest < Test::Unit::TestCase
  
  def setup
    @countdown_field = CountdownField.new(Countdown.new(1))
  end
  
  def test_should_format_time
    assert_equal("00:01", @countdown_field.time)
    @countdown_field.countdown = Countdown.new(60)
    assert_equal("01:00", @countdown_field.time)
    @countdown_field.countdown = Countdown.new( (60*25) -1 )
    assert_equal("24:59", @countdown_field.time)
  end
  
end
