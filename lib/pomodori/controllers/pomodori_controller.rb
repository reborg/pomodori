require 'pomodori/views/main_view'
require 'pomodori/kirby_storage'
require 'pomodori/models/pomodoro'

##
# Pomodoro related operations triggered by
# the UI
#
class PomodoriController
  attr_accessor :storage
  attr_accessor :main_view

  ##
  # Controllers must be initialized with related views.
  #
  def initialize(params = {})
    @main_view = params[:main_view]
  end
  
  ##
  # Creates a new Pomodoro
  #
  def create(params)
    pomodoro = Pomodoro.new(params)
    storage.save(pomodoro)
    storage.invalidate_caches
  end

  ##
  # Returns the count of Pomodoros stored on
  # yesterday.
  #
  def yesterday_pomodoros
    storage.find_all_day_before(Pomodoro, Time.now)
  end
  
  ##
  # Returns the count of Pomodoros stored today.
  #
  def today_pomodoros
    storage.find_all_by_date(Pomodoro, Time.now)
  end
  
  def storage
    @storage ||= KirbyStorage.new
  end
  
  ##
  # Calculates the daily average pomodoros. The rounding
  # is not really important here. I consider only days with more
  # than 6 pomodoros. If less I don't consider them a real
  # day of work but more a few tasks on a holiday.
  # Why 6? 6 can be reasonably an underestimated half a day
  #
  def average_pomodoros
    all = PomodoroCountByDay.find_all
    sum = 0
    valid_day = 0
    all.each do |day|
      if day.count > 5
        valid_day+=1
        sum = sum + day.count
      end
    end
    valid_day > 0 ? sum/valid_day : 0
  end

  def last_tags
    last = storage.last(Pomodoro)
    last.nil? ? [""] : last.tags
  end

  def total_count
    storage.find_all(Pomodoro).size
  end
  
end
