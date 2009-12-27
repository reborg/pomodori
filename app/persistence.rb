framework 'CoreData'

module Persistence

  def self.object_model_from_bundle
    @mom ||= NSManagedObjectModel.mergedModelFromBundles(nil)
  end
  
  def self.applicationSupportFolder
    paths = NSSearchPathForDirectoriesInDomains(
      NSApplicationSupportDirectory, 
      NSUserDomainMask, 
      true)
    basePath = (paths.count > 0) ? paths[0] : NSTemporaryDirectory()
    fileManager = NSFileManager.defaultManager
    path = basePath
      .stringByAppendingPathComponent("Pomodori")
    if !fileManager.fileExistsAtPath(path, isDirectory:nil)
      fileManager.createDirectoryAtPath(path, attributes:nil)
    end
    path
  end
  
  # The single instance managed object context acts as a bridge
  # between the object model and the actual persistence mechanism
  def self.managed_object_context
    return @moc if @moc
      @moc = NSManagedObjectContext.new
      
      # Here a new store coordinator (which knows about persistency)
      # is created with a link to the model. The context is then linked
      # to the store
      coordinator = NSPersistentStoreCoordinator
        .alloc
        .initWithManagedObjectModel(object_model_from_bundle)
      @moc.persistentStoreCoordinator = coordinator
      
      # store as XML file
      url = NSURL
        .fileURLWithPath(applicationSupportFolder.to_s + "/pomodori.xml") 
      # pointer trick, translate the NSError *error declaration
      error = Pointer.new_with_type('@')
      new_store = coordinator
        .addPersistentStoreWithType(
          NSXMLStoreType, 
          configuration:nil, 
          URL:url, 
          options:nil, 

          error:error)
      unless new_store
        msg = error[0].localizedDescription ? 
          error[0].localizedDescription : "Unknown"
        puts "Store configuration error #{msg}"
      end 
    @moc
  end
  
end
