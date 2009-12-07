framework 'Cocoa'
framework 'foundation'

dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
#require dir_path + '/config/environment'
Dir.entries(dir_path).each do |path|
  if path != File.basename(__FILE__) and path[-3..-1] == '.rb'
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
