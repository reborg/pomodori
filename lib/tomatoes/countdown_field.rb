require 'hotcocoa'
require 'tomatoes/frame'

class CountdownField
  attr_accessor :countdown, :frame, :render
  attr_reader :start_time, :state
  include HotCocoa
  
  def initialize(options = {})
    options[:countdown] ? 
      @countdown = Countdown.new(options[:countdown], method(:on_countdown_done)) : 
      @countdown = Countdown.new(25*60, method(:on_countdown_done))
    @frame = options[:frame] ||= Frame.new(0, 0, 96, 35)
    @start_time = Time.now
    @state = :running
  end
  
  def time
    "#{normalize(@countdown.mins)}:#{normalize(@countdown.secs)}"
  end
  
  def render
    @render ||= label(:frame => @frame.to_a, 
      :text => time, 
      :layout => {:expand => :width, :start => false}, 
      :font => font(:system => 30))
  end
  
  private
  
    def normalize(number)
      return "0#{number}" if number < 10
      return number
    end
    
    def on_timer_tick
      @countdown.tick
      if(@state == :running)
        render.text = time
      else
        render.text = "Done!"
      end
    end
    
    def on_countdown_done
      @state = :done
    end
  
end