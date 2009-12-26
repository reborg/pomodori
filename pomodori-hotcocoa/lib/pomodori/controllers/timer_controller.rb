require 'hotcocoa'
require 'pomodori/countdown'

##
# FIXME: rename me TimerController and move me to the controller folder
#
class TimerController
  attr_accessor :countdown
  attr_reader :start_time, :state, :timer
  attr_reader :main_view
  include HotCocoa
  
 POMODORO = 25 * 60
 BREAK = 5 * 60
 #  POMODORO = 5
 #  BREAK = 3
  
  RUNNING = :running
  DONE = :done
  
  def initialize(options = {})
    @main_view = options[:main_view]
    @state = DONE
    # Had to use NSTimer direct call instead of HotCocoa mapping that is
    # affected by a crash after the application start. Returns the hotcocoa
    # rendering
    @timer = NSTimer.scheduledTimerWithTimeInterval(
      1, 
      target:self, 
      selector:'on_timer_tick', 
      userInfo:nil, 
      repeats:true)
  end
  
  def time
    "#{normalize(@countdown.mins)}:#{normalize(@countdown.secs)}"
  end
  
  def on_pomodoro_start
    start_timer(POMODORO, method(:on_pomodoro_done))
  end
  
  def on_break_start
    start_timer(BREAK, method(:on_break_done))
  end
  
  def on_timer_tick
    if(@state == RUNNING)
      @countdown.tick
      @main_view.update_timer(time)
    else
      @main_view.update_timer("Done!")
    end
  end
  
  def on_pomodoro_done
    on_timer_done("submit_mode")
  end
  
  def on_break_done
    on_timer_done("running_mode")
  end
  
  def ring
    bell = sound(
      :file => File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation, 'bell.aif'), 
      :by_reference => true)
    bell.play if bell
  end
    
  private
  
    def normalize(number)
      return "0#{number}" if number < 10
      return number
    end
    
    ##
    # Generic call to start the internal timer with the given number
    # of seconds and an optional callback
    # 
    def start_timer(seconds, callback = lambda {})
      @countdown = Countdown.new(seconds, callback)
      @start_time = Time.now
      @state = RUNNING
    end
    
    ##
    # Generic callback that redirect the message to the main_window
    # 
    def on_timer_done(message)
      @state = DONE
      ring
      @main_view.send(message)
    end
      
end
