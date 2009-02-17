require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/text_field'
require 'pomodori/frame'

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
  
  def test_switch_to_not_editable
    @text_field.disable
    assert_equal(false, @text_field.render.editable?)
  end
  
  def test_switch_to_editable
    @text_field.enable
    assert_equal(true, @text_field.render.editable?)
    assert_equal("", @text_field.render.to_s)
  end
  
end