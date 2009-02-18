class PomodoriController
  attr_accessor :storage
  
  def create(params)
    pomodoro = Pomodoro.new(params)
    storage.save(pomodoro)
  end
  
  def storage
    @storage ||= KirbyStorage.new
  end
  
end