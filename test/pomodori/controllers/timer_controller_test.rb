require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/controllers/timer_controller'
require 'pomodori/countdown'
require 'pomodori/views/main_view'

class TimerControllerTest < Test::Unit::TestCase
  attr_accessor :called
    
  def setup
    @main_view = stub_everything
    @timer_controller = TimerController.new(:main_view => @main_view)
  end
  
  def test_should_update_timer_label_on_timer_done
    @main_view.expects(:update_timer).with("Done!")
    @timer_controller.on_timer_tick
  end
  
  def test_state_is_stopped_after_timers_done
    @timer_controller.on_timer_tick
    assert_equal(:done, @timer_controller.state)
  end
  
  def test_moves_state_to_running_on_startup
    @timer_controller.on_pomodoro_start
    assert_equal(:running, @timer_controller.state)
  end
  
  def test_start_time_was_saved
    @timer_controller.on_pomodoro_start
    assert_not_nil(@timer_controller.start_time)    
  end
  
  def test_should_update_timer_on_tick
    @main_view.expects(:update_timer).with('Done!')
    @timer_controller.on_timer_tick
  end
  
  def test_should_ring
    sound = mock('sound')
    @timer_controller.expects(:sound).returns(sound)
    sound.expects(:play)
    @timer_controller.ring
  end
  
  def test_should_go_submit_on_pomodoro_done
    @main_view.expects(:submit_mode)
    @timer_controller.on_pomodoro_done
  end
  
  def test_should_go_running_on_break_done
    @main_view.expects(:running_mode)
    @timer_controller.on_break_done
  end
  
  def test_should_go_running_on_start_timer
    @timer_controller.send(:start_timer, 1)
    assert_equal(TimerController::RUNNING, @timer_controller.state)
  end
  
  def test_should_initialize_counter
    @timer_controller.send(:start_timer, 120)
    assert_equal(2, @timer_controller.countdown.mins)
  end
  
  def test_should_set_start_time_on_start_timer
    @timer_controller.send(:start_timer, 1)
    assert_in_delta(Time.now.to_f, @timer_controller.start_time.to_f, 0.01)
  end
  
  def test_main_view_should_receive_message_on_timer_done
    @main_view.expects(:message)
    @timer_controller.send(:on_timer_done, "message")
  end
    
  ##
  # this should move to summary controller.
  #
  # def test_should_format_time
  #   @timer_controller.start(1)
  #   assert_equal("00:01", @timer_controller.time)
  #   @timer_controller.start(60)
  #   assert_equal("01:00", @timer_controller.time)
  #   @timer_controller.start( (60*25)-1 )
  #   assert_equal("24:59", @timer_controller.time)
  # end

end

