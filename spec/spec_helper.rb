require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'mocha'
require 'microspec'
require 'matchy'
require 'test/unit'
framework 'coredata'
TEST_BUNDLE_PATH = File.dirname(__FILE__) + "/test_db"
TEST_DB_PATH = TEST_BUNDLE_PATH + "/pomodori.xml"

require File.expand_path(File.dirname(__FILE__) + "/spec_commons")
include SpecCommons
