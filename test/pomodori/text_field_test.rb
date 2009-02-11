require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/text_field'

class TextFieldTest < Test::Unit::TestCase
  
  def setup
    @text_field = TextField.new
  end
  
  def test_init_with_default_frame
    assert_equal(@text_field.frame, Frame.new(0, 0, 100, 30))
  end
  
  def test_init_custom_frame
    text_field = TextField.new(Frame.new(1,1,1,1))
    assert_equal(text_field.frame, Frame.new(1,1,1,1))
  end
  
  def test_should_render_cocoa
    @text_field.expects(:text_field)
    @text_field.render
  end
  
end