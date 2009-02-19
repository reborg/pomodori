require 'hotcocoa'
require 'pomodori/frame'

##
# Encapsulates all the logic related to the display of the
# timer on the screen. An NSTimer is used as ticking mechanism
# and never stops. Usage of the class:
# c = CountdownField.new
# c.start(25*60)
# c.render
#
class CountdownField
  attr_accessor :countdown, :frame, :render
  attr_reader :start_time, :state, :timer
  include HotCocoa
  
  ##
  # Starts to count from 25 minutes by default. Overridable.
  #
  def initialize(options = {})
    @frame = options[:frame] ||= Frame.new(0, 0, 96, 35)
    @state = :done
    @timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:'on_timer_tick', userInfo:nil, repeats:true)
  end
  
  def time
    "#{normalize(@countdown.mins)}:#{normalize(@countdown.secs)}"
  end
  
  ##
  # Had to use NSTimer direct call instead of HotCocoa mapping that is
  # affected by a crash after the application start. Returns the hotcocoa
  # rendering
  #
  def start(from, on_timer_done = nil)
    callback = lambda do
      @state = :done
      on_timer_done.call if on_timer_done
    end
    @countdown = Countdown.new(from, callback)
    @start_time = Time.now
    @state = :running
    render
  end
  
  def on_timer_tick
    if(@state == :running)
      @countdown.tick
      render.text = time
    else
      render.text = "Done!"
    end
  end
  
  def render
    @render ||= label(:frame => @frame.to_a,
      :text => time, 
      :layout => {:expand => :width, :start => false}, 
      :font => font(:name => "Monaco", :size => 26))
  end
  
  private
  
    def normalize(number)
      return "0#{number}" if number < 10
      return number
    end
      
end