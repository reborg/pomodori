lib_path = File.expand_path(File.dirname(__FILE__) + "/../mocha/lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require "mocha"
require "test/unit"
require File.dirname(__FILE__) + '/../lib/tomatoes'