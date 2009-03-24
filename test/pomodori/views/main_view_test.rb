require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/main_view'

class MainViewTest < Test::Unit::TestCase
  attr_accessor :called
  
  def setup
    @modal_button_controller = mock("modal_button_controller")
    @modal_button_controller.class.send(:define_method, :on_click_void, lambda{})
    @modal_button_controller.class.send(:define_method, :on_click_submit, lambda{})
    @main_view = MainView.new(:modal_button_controller => @modal_button_controller)
  end
  
  def test_should_go_running_mode_on_init
    @main_view.expects(:running_mode)
    @main_view.send(:initialize)
  end
  
  def test_should_change_timer_label
    @main_view.update_timer("hey")
    assert("hey", @main_view.timer_label)
  end
  
  def test_switch_off_input_box
    @main_view.send(:disable_input_box)
    assert_equal(false, @main_view.summary_label.editable?)
  end
  
  def test_switch_off_input_box_with_message
    @main_view.send(:disable_input_box, "good")
    assert_equal("good", @main_view.summary_label.to_s)
  end
  
  def test_switch_on_input_box
    @main_view.send(:enable_input_box)
    assert_equal(true, @main_view.summary_label.editable?)
    assert_equal("Pomodoro description here", @main_view.summary_label.to_s)
  end
  
  def test_switch_to_submit_mode
    @main_view.expects(:enable_input_box)
    @main_view.submit_mode
    assert_equal("Submit", @main_view.modal_button.title)
  end
  
  def test_should_update_modal_label
    @main_view.update_modal_button_label("cips")
    assert_equal("cips", @main_view.modal_button.title)
  end
  
end