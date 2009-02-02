task :default => [:test]

task :build do
  require 'hotcocoa/application_builder'
  ApplicationBuilder.build :file => "config/build.yml"
end

task :run => [:clean, :build] do
  require 'yaml'
  app_name = YAML.load(File.read("config/build.yml"))[:name]
  `open "#{app_name}.app"`
end

task :clean do
  require 'yaml'
  app_name = YAML.load(File.read("config/build.yml"))[:name]
  `rm -rf "#{app_name}.app"`
end

task :test do
  require 'open3'
	Open3.popen3('macruby test/tomatoes/all_tests.rb') { |stdin, stdout, stderr| puts stdout.read }
end