require 'rubygems'
require 'hotcocoa/application_builder'
require 'hotcocoa/standard_rake_tasks'

task :default => [:test]

task :test do
  require 'open3'
  Open3.popen3('macruby test/all_tests.rb') { |stdin, stdout, stderr| puts stdout.read }
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

