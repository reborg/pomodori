require 'persistent_object'

class Pomodoro < PersistentObject

  ##
  # Initialization with optional attributes. Attributes
  # are defined as part of the managed object model.
  def initialize(opts = {})
    self.text = opts.delete(:text) 
    self.timestamp = opts.delete(:timestamp) || NSDate.date
  end

  def tags
    @text.scan(/@\w+/)
  end

end
