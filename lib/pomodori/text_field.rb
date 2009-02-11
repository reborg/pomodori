require 'hotcocoa'

class TextField
  include HotCocoa
  attr_reader :frame, :render
    
  def initialize(_frame = frame)
    @frame = _frame
  end
  
  def frame
    @frame ||= Frame.new(0, 0, 100, 30)
  end
  
  def render
    @render ||= text_field(:frame => frame.to_a)
  end
  
end