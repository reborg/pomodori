class Countdown
  attr_accessor :secs, :callback
  
  def initialize(secs, block = lambda {})
    @secs = secs
    @callback = block
  end
  
  def mins
    @secs / 60
  end
  
  def secs
    @secs % 60
  end
  
  def tick
    if @secs > 1
      @secs -= 1
    else
      @secs = 0
      @callback.call
    end
  end
  
end
