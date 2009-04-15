require 'pomodori/views/main_view'
require 'pomodori/kirby_storage'
require 'pomodori/models/pomodoro'

class PomodoriController
  attr_accessor :storage
  attr_accessor :main_view

  def initialize(params = {})
    @main_view = params[:main_view]
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
  
  ##
  # Calculates the daily average pomodoros
  #
  def daily_average
    all = PomodoroCountByDay.find_all
    (all.inject(0) { |sum, day| sum + day.count}) / all.size    
  end
  
end