#$LOAD_PATH.unshift(File.dirname(__FILE__) + "/vendor/hotcocoa-0.5.1+patch/lib")

APPSPEC = 'config/Pomodori.appspec'

require 'rubygems'
require 'hotcocoa/rake_tasks'

task :default => [:test]

task :test do
  `macruby test/all_tests.rb`
end

#task :embed => [:deploy] do
#  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/bin`
#  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/libmacruby-static.a`
#  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/ruby/Gems`
#  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/ruby/1.9.0/rubygems`
#  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/ruby/1.9.0/irb`
#  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/ruby/1.9.0/rdoc`
#  `rm -rf ./#{AppConfig.name}.app/Contents/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/share`
#  `find ./#{AppConfig.name}.app/Contents -name "*.rbo" -exec install_name_tool -change /Library/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/libmacruby.dylib @executable_path/../Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/libmacruby.dylib {} \\;`
#  `find ./#{AppConfig.name}.app/Contents -name "*.bundle" -exec install_name_tool -change /Library/Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/libmacruby.dylib @executable_path/../Frameworks/MacRuby.framework/Versions/#{MACRUBY_VERSION}/usr/lib/libmacruby.dylib {} \\;`
#end
