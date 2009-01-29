lib_path = File.expand_path(File.dirname(__FILE__) + "/../mocha/lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require "mocha"
require "test/unit"

Dir.glob(File.join(File.dirname(__FILE__), '../lib/*.rb')).each {|f| require f unless f.match(/application.rb/)}