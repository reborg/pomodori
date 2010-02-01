require 'countdown'

class TimerController
  attr_accessor :countdown, :timer_label
  attr_reader :start_time, :state, :timer
  
  POMODORO = 25 * 60
  BREAK = 5 * 60
   #  POMODORO = 5
   #  BREAK = 3
  
  RUNNING = :running
  DONE = :done
  
  def initialize(options = {})
    @state = DONE
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
  
  def on_pomodoro_start(sender)
    start_timer(POMODORO, method(:on_pomodoro_done))
  end
  
  def on_break_start(sender)
    start_timer(BREAK, method(:on_break_done))
  end
  
  def on_timer_tick
    if(@state == RUNNING)
      @countdown.tick
      timer_label.stringValue = time
    else
      timer_label.stringValue = "Done!"
    end
  end
  
  def on_pomodoro_done
  end
  
  def on_break_done
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
    
end
