framework 'foundation'
require 'pomodoro'

class PomodoriController
  attr_accessor :text_area
  def create(sender)
    @pomodoro = Pomodoro.new(:text => @text_area.label.to_s)
    if(@pomodoro.save)
      NSLog("Controller created pomodoro")
    else
      # WarningsController.new
      # warnings.show('Was not possible to save your pomodoro')
    end
  end
end
