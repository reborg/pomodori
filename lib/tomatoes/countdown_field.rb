require 'hotcocoa'
require 'tomatoes/frame'

class CountdownField
  attr_accessor :countdown, :frame, :rendered
  include HotCocoa
  
  def initialize(options = {})
    @countdown = options[:countdown] ||= Countdown.new(25*60)
    @frame = options[:frame] ||= Frame.new(0, 0, 96, 35)
  end
  
  def time
    "#{normalize(@countdown.mins)}:#{normalize(@countdown.secs)}"
  end
  
  def tick
    @countdown.tick
    @rendered.text = time
  end
  
  def render
    @rendered = label(:frame => @frame.to_a, 
      :text => time, 
      :layout => {:expand => :width, :start => false}, 
      :font => font(:system => 30))
  end
  
  private
  
    def normalize(number)
      return "0#{number}" if number < 10
      return number
    end
  
end