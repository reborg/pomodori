require 'pomodoro'

class PomodoriController
  attr_accessor :text_area
  attr_accessor :submit_button
  def create(sender)
    if(Pomodoro.save(@text_area.stringValue))
      NSLog("Controller created pomodoro")
      @text_area.setHidden(true)
      @submit_button.setHidden(true)
    else
      NSLog("Persistence ERROR")
      # WarningsController.new
      # warnings.show('Was not possible to save your pomodoro')
    end
  end

end
