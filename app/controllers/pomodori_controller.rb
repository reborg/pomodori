require 'pomodoro'

class PomodoriController

  attr_accessor :text_area
  attr_accessor :submit_button

  def create(sender)
    pomodoro = Pomodoro.new(:text => @text_area.stringValue)
    if(pomodoro.save)
      NSLog("Controller created pomodoro")
    else
      NSLog("Persistence ERROR")
      # WarningsController.new
      # warnings.show('Was not possible to save your pomodoro')
    end
  end

end
