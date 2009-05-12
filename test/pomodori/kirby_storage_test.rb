require File.dirname(__FILE__) + '/../test_helper'
require 'thirdparties/kirbybase'
require 'pomodori/kirby_storage'
require 'pomodori/models/pomodoro'

class KirbyStorageTest < Test::Unit::TestCase
  
  def setup
    @path = File.dirname(__FILE__) + "/../work"
    create_db(@path)
    @kirby_storage = KirbyStorage.new(@path)
  end
  
  it "retrieves table for instances or classes" do
    @kirby_storage.send(:table_for, Pomodoro.new).should_not be_nil
    @kirby_storage.send(:table_for, Pomodoro).should_not be_nil
  end
  
  it "should convert lowercase" do
    db = mock('db')
    @kirby_storage.db = db
    db.expects(:get_table).at_least(2).with(:pomodoro)
    @kirby_storage.send(:table_for, Pomodoro)
    @kirby_storage.send(:table_for, Pomodoro.new)
  end
  
  it "creates a record" do
    @kirby_storage.save(Pomodoro.new(:text => "done!"))
    @kirby_storage.find_all(Pomodoro).size.should == 1
  end
  
  it "returns all pomodori" do
    bulk_import_test_data
    @kirby_storage.find_all(Pomodoro).size.should == 32
  end
  
  it "returns all pomodoros by date" do
    bulk_import_test_data
    date = Time.local(2009, "feb", 16, "5", "25")
    @kirby_storage.find_all_by_date(Pomodoro, date).size.should == 5
  end
  
  def teardown
    wipe_dir(@path)
  end
  
  private
    
    def create_db(path)
      db = KirbyStorage.init_db(path)
      # db.drop_table(:pomodoro) if db.table_exists?(:pomodoro)
    end
    
    def bulk_import_test_data
      open("#{@path}/pomodoro.tbl", 'w') do |output|
        open(File.dirname(__FILE__) + '/pomodoro_test_data.txt') do |input|
          input.readlines.each {|line| output.write(line)}
        end
      end
    end

end