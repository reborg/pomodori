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
  
  def disable
    render.text_align = NSCenterTextAlignment
    render.setDrawsBackground(false)
    render.setBordered(false)
    render.setSelectable(false)
    render.editable = false
    render.text = "...running"
    render
  end

  def enable
    render.text_align = NSLeftTextAlignment
    render.setDrawsBackground(true)
    render.setBordered(true)
    render.setSelectable(true)
    render.editable = true
    render.text = ""
    render
  end
  
end