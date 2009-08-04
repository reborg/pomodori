require 'hotcocoa/application_builder'
require 'hotcocoa/standard_rake_tasks'

task :default => [:test]

task :test do
  require 'open3'
  Open3.popen3('macruby test/all_tests.rb') { |stdin, stdout, stderr| puts stdout.read }
end

task :embed => [:deploy] do
  root = "Frameworks/MacRuby.framework/Versions/Current"
  `rm -rf ./#{AppConfig.name}.app/Contents/#{root}/0.3`
  `find ./#{AppConfig.name}.app/Contents -name "1.9.0" -type d | xargs rm -rf`
  `rm -rf ./#{AppConfig.name}.app/Contents/#{root}/usr/include/ruby-1.9.0`
  `rm -rf ./#{AppConfig.name}.app/Contents/#{root}/usr/lib/libmacruby.1.9.0.dylib`
  `find ./#{AppConfig.name}.app/Contents -name "*.bundle" \
    -exec install_name_tool -change \
    /Library/#{root}/usr/lib/libmacruby.dylib \
    @executable_path/../#{root}/usr/lib/libmacruby.dylib {} \\;`
end

