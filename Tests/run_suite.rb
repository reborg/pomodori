require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
Dir.glob(File.expand_path('../**/*_test.rb', __FILE__)).each { |test| require test }
