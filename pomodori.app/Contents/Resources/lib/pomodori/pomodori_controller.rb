class PomodoriController
  attr_accessor :storage
  
  def create(params)
    pomodoro = Pomodoro.new(params)
    storage.save(pomodoro)
  end
  
  def yesterday_pomodoros
    storage.yesterday_pomodoros.size
  end
  
  def today_pomodoros
    storage.today_pomodoros.size
  end
  
  def storage
    @storage ||= KirbyStorage.new
  end
  
end