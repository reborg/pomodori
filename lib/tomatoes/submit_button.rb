require 'hotcocoa'

##
# If initialized with an empty constructor it simply takes
# the defaults for everything. You probably want to configure at least
# the callback action:
#
# button = SubmitButton.new(Proc.new { # your callback code here })
#
class SubmitButton
  include HotCocoa
  attr_accessor :action, :frame, :title

  def initialize(_action = action, _frame = frame, _title = title)
    @action = _action
    @frame = _frame
    @title = _title
  end

  def title
    @title ||= "Submit"
  end

  ##
  # Creates a new deafult frame if none is given first
  # 
  def frame
    @frame ||= Frame.new(0, 0, 96, 32)
  end
  
  def action
    @action ||= Proc.new {alert :message => "Button clicked."}
  end
  
  ##
  # Produces the HotCocoa related instance
  #
  def render
    button(
      :title => title, 
      :frame => frame.to_a, 
      :bezel => :rounded, 
      :layout => {:expand => :width, :start => false}, 
      :on_action => action)
  end
  
end