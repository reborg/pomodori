require 'pomodoro'

class PomodoriController
  attr_accessor :text_area
  def create(sender)
    if(Pomodoro.save(@text_area.stringValue))
      NSLog("Controller created pomodoro")
    else
      # WarningsController.new
      # warnings.show('Was not possible to save your pomodoro')
    end
  end

end
