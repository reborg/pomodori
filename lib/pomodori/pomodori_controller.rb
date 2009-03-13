require 'pomodori/views/main_view'

class PomodoriController
  attr_accessor :storage
  attr_accessor :main_view

  def initialize(params = {})
    @main_view = params[:main_view] ||= MainView.new
  end
  
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
  
  def void_pomodoro
    @main_view.now_counting = 'Break'
    @main_view.timer = 5*60
    @main_view.modal_button = 'Restart'
  end
  
end