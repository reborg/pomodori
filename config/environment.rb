framework 'coredata'
APP_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

[".", "models", "controllers", "views"].each do |path|
  $LOAD_PATH << APP_ROOT + "/app/" + path
end

# Get vendor libs into the loadpath:
[ "microspec/lib", "mhennemeyer-matchy-0.3.3/lib", "mocha-0.9.5/lib" ].each do |path|
  $LOAD_PATH << APP_ROOT + "/vendor/" + path
end
