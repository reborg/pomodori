require 'persistence'

class Pomodoro < NSManagedObject
  include Persistence
  
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
      puts "Error while saving entity #{msg}"
    end

  end

end
