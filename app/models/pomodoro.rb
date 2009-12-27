require 'persistence'

class Pomodoro < NSManagedObject
  attr_reader :timestamp, :text
  def initialize(opts = {})
    @text = opts.delete(:text) 
    @timestamp = opts.delete(:timestamp) || NSDate.date
  end
  def tags
    @text.scan(/@\w+/)
  end
  def self.save(text)
    mom = Persistence.object_model_from_bundle
    moc = Persistence.managed_object_context
    pomodoro_entity = mom.entitiesByName[:Pomodoro]
    pomodoro = Pomodoro.alloc.initWithEntity(pomodoro_entity, insertIntoManagedObjectContext:moc)
    pomodoro.text = text
    pomodoro.timestamp = NSDate.date
    error = Pointer.new_with_type('@')
    unless moc.save(error)
      msg = error[0].localizedDescription ?  error[0].localizedDescription : "Unknown"
      NSLog("Error while saving entity #{msg}")
      return false
    end
    return true
  end
  def self.count
    mom = Persistence.object_model_from_bundle  
    moc = Persistence.managed_object_context
    run_entity = mom.entitiesByName[:Pomodoro]
    request = NSFetchRequest.new
    request.entity = run_entity
    sort_descriptor = NSSortDescriptor.alloc.initWithKey("timestamp", ascending:true)
    request.sortDescriptors = [sort_descriptor]
    fetch_error = Pointer.new_with_type('@')
    results = moc.executeFetchRequest(request, error:fetch_error)
    if ((fetch_error[0] != nil) || (results == nil))
      msg = fetch_error[0].localizedDescription ? 
      fetch_error[0].localizedDescription : "Unknown"
      puts "Error fetching entity #{msg}"
    end
    results.size
  end
end
