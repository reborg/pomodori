class PomodoriController
  
  def create(params)
    pomodoro = Pomodoro.new(params)
    storage = KirbyStorage.new
    storage.save(pomodoro)
  end
  
end