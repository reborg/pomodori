require 'persistence'

##
# ActiveRecord like persistence based on CoreData. WIP.
class PersistentObject < NSManagedObject

  ##
  # Initialization hook to return a managed object
  # instance instead.
  def self.new(*args, &block)
    obj = self.alloc.initWithEntity(entity, insertIntoManagedObjectContext:Persistence.instance.moc)
    obj.send(:initialize, *args, &block)
    obj
  end

  def self.entity
    Persistence.instance.mom.entitiesByName[self.name]
  end

  ##
  # Saves an already existing instance to the database.
  def save
    Persistence.save
  end

  ##
  # Creates a new instance for the entity and assign
  # all attributes passed in as params.
  def self.create(params)
    new_instance = constantize(entity.name).new
    params.keys.each {|attr| new_instance.send("#{attr}=", params[attr])}
    new_instance.save
  end

  ##
  # Same as create but throws exception instead of false
  # if save operation fails.
  def self.create!(params)
    unless create(params)
      raise Exception, "Could not create entity"
    end
  end

  ##
  # Predicate syntax reference:
  # http://tinyurl.com/ybr5tve
  def self.find_by_text(str)
    request = NSFetchRequest.new
    request.includesPendingChanges = false
    request.entity = entity
    request.predicate = NSPredicate.predicateWithFormat("%K like %@", "text", str)
    Persistence.fetch(request).first
  end

  def self.all
    request = NSFetchRequest.new
    request.includesPendingChanges = false
    request.entity = entity
    Persistence.fetch(request)
  end

  ##
  # FIXME: Poor man count until I find how to select count
  #
  # with coredata.
  def self.count
    all.count
  end

  def self.constantize(camel_cased_word)
    unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
      raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
    end
    Object.module_eval("::#{$1}", __FILE__, __LINE__)
  end

end
