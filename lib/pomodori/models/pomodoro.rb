class Pomodoro
  attr_accessor :text, :timestamp
  
  def initialize(params = {})
    @text = params[:text]
    @timestamp = params[:timestamp]
  end
  
  def timestamp
    @timestamp ||= Time.now.to_s
  end
  
  def tags
    @text.scan(/@\w+/)
  end
  
end
