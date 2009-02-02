require File.dirname(__FILE__) + '/../test_helper'
require 'tomatoes/frame'

class FrameTest < Test::Unit::TestCase
  
  def setup
    x = y = 0
    width = 300
    height = 100
    @frame1 = Frame.new(x, y, width, height)
    @frame2 = Frame.new(0, 0, 50, 50)
  end
  
  def test_should_verify_equality
    assert(@frame1 == Frame.new(0, 0, 300, 100))
  end
  
  def test_should_return_an_array_rappresentation
    assert_equal([0,0,50,50], @frame2.to_a)
  end
    
end