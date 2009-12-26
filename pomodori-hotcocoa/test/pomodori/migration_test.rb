require File.dirname(__FILE__) + '/../test_helper'
require "pomodori/migration"

class MigrationTest < Test::Unit::TestCase
  
  def setup
    @migration = Migration
    @migrate_me = File.dirname(__FILE__) + '/../work/migrate_me.tbl'
    @do_not_migrate_me = File.dirname(__FILE__) + '/../work/do_not_migrate_me.tbl'
    create_table(@migrate_me, "Time")
    create_table(@do_not_migrate_me, "String")
  end
  
  it "replaces old timestamp declaration with new string" do
    Migration.migrate(@migrate_me)
    open(@migrate_me) do |input|
      input.read.should_not =~ Migration::TIMESTAMP_REGEXP
    end
  end
  
  it "should not change an already existent migrated tbl" do
    expected = File.read(@do_not_migrate_me)
    Migration.migrate(@do_not_migrate_me)
    File.read(@do_not_migrate_me).should == expected
  end
  
  def teardown
    wipe_dir(File.dirname(__FILE__) + "/../work")
  end
  
  def create_table(file, type)
    File.open(file, 'w+') do |f| 
      f << example_raw_dump.gsub(/thetypehere/, type)
    end
  end
  
  def example_raw_dump
    <<-MESSAGE
    000035|000000|Struct|recno:Integer|text:String|thetypehere:String
    1|it works!|2009-02-12 09:57:17 -0600
    5|@planning review of the 5 minutes timer technical details|2009-02-12 14:55:00 -0600
    6|@keyboardevents searching how to connect return keypressed to action|2009-02-13 10:18:03 -0600
    7|@keyboardevents tried to fix the disappeared menu|2009-02-13 10:46:46 -0600
    8|@keyboardevents studying what the possibilities are, but the situation is not very good.|2009-02-13 11:21:05 -0600
    9|@keyboardevents oriented to try out the NSResponder|2009-02-14 14:50:57 -0600
    MESSAGE
  end
    
end