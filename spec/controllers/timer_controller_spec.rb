require File.dirname(__FILE__) + "/../spec_helper"
require 'controllers/timer_controller'
require 'models/countdown'

class TimerControllerSpec < Test::Unit::TestCase
  attr_accessor :called
    
  def setup
    @timer_controller = TimerController.new
    @timer_label = mock('timer_label')
    @timer_controller.stubs(:timer_label).returns(@timer_label)
  end
  
  def test_should_update_timer_label_on_timer_done
    @timer_label.expects(:stringValue=).with("Done!")
    @timer_controller.on_timer_tick
  end
  
  def test_state_is_stopped_after_timers_done
    @timer_label.stubs(:stringValue=)
    @timer_controller.on_timer_tick
    assert_equal(:done, @timer_controller.state)
  end
  
  def test_moves_state_to_running_on_startup
    @timer_controller.on_pomodoro_start(nil)
    assert_equal(:running, @timer_controller.state)
  end
  
  def test_start_time_was_saved
    @timer_controller.on_pomodoro_start(nil)
    assert_not_nil(@timer_controller.start_time)    
  end
  
  def test_should_ring
    sound = mock('sound')
    @timer_controller.expects(:sound).returns(sound)
    sound.expects(:play)
    @timer_controller.ring
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
  
  def test_should_format_time
    @timer_controller.send(:start_timer, 1)
    assert_equal("00:01", @timer_controller.time)
    @timer_controller.send(:start_timer, 60)
    assert_equal("01:00", @timer_controller.time)
    @timer_controller.send(:start_timer, 60*25-1)
    assert_equal("24:59", @timer_controller.time)
  end

end

