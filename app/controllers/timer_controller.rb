class TimerController
  attr_accessor :timer_label
  
  def awakeFromNib
    NSTimer.scheduledTimerWithTimeInterval( 1, target:self, selector:'on_timer_tick', userInfo:nil, repeats:true)
  end
  
  def on_timer_tick
    @timer_label.stringValue = Time.now.strftime("%M:%S")
  end
      
end
