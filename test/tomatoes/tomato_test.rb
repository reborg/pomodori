require File.dirname(__FILE__) + '/../test_helper'
require 'tomatoes/tomato'

class TomatoTest < Test::Unit::TestCase
  
  def setup
    @tomato = Tomato.new
  end
  
  def test_intializes_with_arg_hash
    now = DateTime.now
    tomato = Tomato.new({:text => "hola", :timestamp => now})
    assert_equal("hola", tomato.text)
    assert_equal(now, tomato.timestamp)
  end
  
  def test_has_default_timestamp
    assert_not_nil(@tomato.timestamp)
  end
  
end
