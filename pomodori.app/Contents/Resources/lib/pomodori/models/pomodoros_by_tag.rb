class PomodorosByTag
  
  def initialize
    @hash = Hash.new
  end
  
  def count(tag)
    pomodoros_for_tag(tag).size
  end
  
  def add(pomodoro)
    tags = extract_from(pomodoro)
    tags.each do |tag| 
      pomodoros_for_tag(tag) << pomodoro
    end
  end
  
  def extract_from(pomodoro)
    ['tag', 'something']
  end
  
  def pomodoros_for_tag(tag)
    @hash[tag] ||= Array.new
  end
  
end