require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/controllers/modal_button_controller'
require 'pomodori/views/main_view'

class ModalButtonControllerTest < Test::Unit::TestCase
  
  def setup
    @main_view = MainView.new
    @modal_button_controller = ModalButtonController.new(:main_view => @main_view)
  end
  
  def test_set_button_and_action_on_init
    assert_equal("Void", @main_view.modal_button.title)
  end
  
  def test_should_switch_to_break_mode_on_void_click
    when_goes_into_break_mode(:on_click_void)
  end
  
  def test_should_go_running_mode_on_restart
    @main_view.expects(:running_mode)
    @main_view.expects(:update_modal_button_action).with do |a_block|
      assert_match(/on_click_void/, a_block.name)
    end
    @modal_button_controller.on_click_restart("sender")
    assert_equal("Void", @main_view.modal_button.title)
  end
  
  def test_should_switch_to_break_on_submit
    when_goes_into_break_mode(:on_click_submit)
  end
  
  def when_goes_into_break_mode(action)
    @main_view.expects(:break_mode)
    @main_view.expects(:update_modal_button_action).with do |a_block|
      assert_match(/on_click_restart/, a_block.name)
    end
    @modal_button_controller.send(action, "sender")
    assert_equal("Restart", @main_view.modal_button.title)
  end
  
end