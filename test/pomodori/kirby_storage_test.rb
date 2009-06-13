require File.dirname(__FILE__) + '/../test_helper'
require 'thirdparties/kirbybase'
require 'pomodori/kirby_storage'
require 'pomodori/migration'
require 'pomodori/models/pomodoro'

class KirbyStorageTest < Test::Unit::TestCase
  
  def setup
    @path = File.dirname(__FILE__) + "/../work"
    Migration.init_db(@path)
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
  
  it "returns all pomodori" do
    bulk_import_test_data
    @kirby_storage.find_all(Pomodoro).size.should == 32
  end
  
  it "returns all pomodoros by date" do
    bulk_import_test_data
    date = Time.local(2009, "feb", 16, "5", "25")
    @kirby_storage.find_all_by_date(Pomodoro, date).size.should == 5
  end

  it 'should retrieve the last pomodoro' do
    bulk_import_test_data
    pomodoro = @kirby_storage.last(Pomodoro)
    pomodoro.text.should == "@planning just arranged tasks and wrote new tasks."
    pomodoro.should be_instance_of(Pomodoro)
  end

  it 'caches pomodoros' do
    table = mock()
    table.expects(:select).returns(["a", "b"])
    @kirby_storage.expects(:table_for).once.returns(table)
    @kirby_storage.find_all(Pomodoro)
    @kirby_storage.find_all(Pomodoro)
  end
  
  def teardown
    @kirby_storage.invalidate_caches
    #wipe_dir(@path)
  end
  
  private
    
    def bulk_import_test_data
      `cp #{File.dirname(__FILE__) + '/pomodoro_test_data.txt'} #{@path}/pomodoro.tbl`
    end

end
