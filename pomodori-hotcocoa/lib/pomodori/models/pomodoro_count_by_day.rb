require 'pomodori/kirby_storage'

class PomodoroCountByDay
  attr_reader :date, :pomodoros
  include Comparable
  
  def initialize(date, pomodoros = [])
    @date = date
    @pomodoros = pomodoros
  end
  
  def count
    @pomodoros.size
  end
  
  def <<(pomodoro)
    @pomodoros << pomodoro
  end
  
  def <=>(pomodoro_count)
    date <=> pomodoro_count.date
  end
  
  ##
  # FIXME: filtering logic should go down to kirby_storage
  # if loading all pomos is overkill.
  #
  def self.find_all
    hash = {}
    all_pomodoros = KirbyStorage.new.find_all(Pomodoro)
    all_pomodoros.each do |pomodoro|
      ts = pomodoro.timestamp.flatten_date
      hash[ts] = PomodoroCountByDay.new(pomodoro.timestamp) unless hash[ts]
      hash[ts] << pomodoro
    end
    hash.values.sort.reverse
  end
  
end