require 'hotcocoa'

class CountdownField
  attr_accessor :countdown
  
  def initialize(countdown = Countdown.new(25*60))
    @countdown = countdown
  end
  
  def time
    "#{normalize(@countdown.mins)}:#{normalize(@countdown.secs)}"
  end
  
  private
  
    def normalize(number)
      return "0#{number}" if number < 10
      return number
    end
  
end