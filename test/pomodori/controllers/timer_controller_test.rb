require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/controllers/timer_controller'
require 'pomodori/countdown'
require 'pomodori/views/main_view'

class CountdownFieldTest < Test::Unit::TestCase
  attr_accessor :called
    
  def setup
    @main_view = stub_everything
    @countdown_field = TimerController.new(:main_view => @main_view)
  end
  
  def test_should_update_timer_label_on_timer_done
    @main_view.expects(:update_timer).with("Done!")
    @countdown_field.on_timer_tick
  end
  
  def test_state_is_stopped_after_timers_done
    @countdown_field.on_timer_tick
    assert_equal(:done, @countdown_field.state)
  end
  
  def test_moves_state_to_running_on_startup
    @countdown_field.on_pomodoro_start
    assert_equal(:running, @countdown_field.state)
  end
  
  def test_start_time_was_saved
    @countdown_field.on_pomodoro_start
    assert_not_nil(@countdown_field.start_time)    
  end
  
  def test_should_update_timer_on_tick
    @main_view.expects(:update_timer).with('Done!')
    @countdown_field.on_timer_tick
  end
  
  def test_should_ring
    sound = mock('sound')
    @countdown_field.expects(:sound).returns(sound)
    sound.expects(:play)
    @countdown_field.ring
  end
  
  def test_should_go_submit_on_pomodoro_done
    @main_view.expects(:submit_mode)
    @countdown_field.on_pomodoro_done
  end
  
  def test_should_go_running_on_break_done
    @main_view.expects(:running_mode)
    @countdown_field.on_break_done
  end
  
  def test_should_go_running_on_start_timer
    @countdown_field.send(:start_timer, 1)
    assert_equal(TimerController::RUNNING, @countdown_field.state)
  end
  
  def test_should_initialize_counter
    @countdown_field.send(:start_timer, 120)
    assert_equal(2, @countdown_field.countdown.mins)
  end
  
  def test_should_set_start_time_on_start_timer
    @countdown_field.send(:start_timer, 1)
    assert_in_delta(Time.now.to_f, @countdown_field.start_time.to_f, 0.01)
  end
  
  def test_main_view_should_receive_message_on_timer_done
    @main_view.expects(:message)
    @countdown_field.send(:on_timer_done, "message")
  end
    
  ##
  # this should move to summary controller.
  #
  # def test_should_format_time
  #   @countdown_field.start(1)
  #   assert_equal("00:01", @countdown_field.time)
  #   @countdown_field.start(60)
  #   assert_equal("01:00", @countdown_field.time)
  #   @countdown_field.start( (60*25)-1 )
  #   assert_equal("24:59", @countdown_field.time)
  # end

end

