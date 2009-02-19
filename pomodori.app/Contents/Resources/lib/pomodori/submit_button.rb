require 'hotcocoa'

class SubmitButton
  include HotCocoa
  attr_accessor :action, :frame, :title, :render

  def initialize(options = {})
    @action = options[:action] ||= Proc.new {alert :message => "Button clicked."}
    @frame = options[:frame] ||= Frame.new(0, 0, 96, 32)
    @title = options[:title] ||= "Submit"
  end
  
  def label=(new_label)
    @title = new_label
    render.title = @title
  end
  
  def action=(new_action)
    @action = new_action
    render.on_action = new_action
  end

  def render
    @render ||= button(
      :title => title, 
      :frame => frame.to_a, 
      :bezel => :rounded, 
      :layout => {:expand => :width, :start => false}, 
      :on_action => action)
  end
  
end