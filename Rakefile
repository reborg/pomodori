require 'rubygems'

task :default => [:test]

task :test do
  IO.popen('macruby test/all_tests.rb')
  puts $?
end

task :embed => [:deploy] do
  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/Current/usr/bin`
  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/Current/usr/lib/libmacruby-static.a`
  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/Current/usr/lib/ruby/Gems`
  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/Current/usr/lib/ruby/1.9.0/rubygems`
  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/Current/usr/lib/ruby/1.9.0/irb`
  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/Current/usr/lib/ruby/1.9.0/rdoc`
  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/Current/usr/share`
  `find ./#{AppConfig.name}.app/Contents -name "*.rbo" -exec install_name_tool -change /Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/libmacruby.dylib @executable_path/../Frameworks/MacRuby.framework/Versions/0.5/usr/lib/libmacruby.dylib {} \\;`
  `find ./#{AppConfig.name}.app/Contents -name "*.bundle" -exec install_name_tool -change /Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/libmacruby.dylib @executable_path/../Frameworks/MacRuby.framework/Versions/0.5/usr/lib/libmacruby.dylib {} \\;`
end

