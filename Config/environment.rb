APP_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

[".", "Models", "Controllers", "Views"].each do |path|
  $LOAD_PATH << APP_ROOT + "/Classes/" + path
end

# Get vendor libs into the loadpath:
[ "microspec/lib", "mhennemeyer-matchy-0.3.3/lib", "mocha-0.9.5/lib" ].each do |path|
  $LOAD_PATH << APP_ROOT + "/Vendor/" + path
end
