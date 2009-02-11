require File.dirname(__FILE__) + '/../test_helper'
require 'thirdparties/kirbybase'
require 'pomodori/kirby_storage'
require 'pomodori/pomodoro'

class KirbyStorageTest < Test::Unit::TestCase
  
  def setup
    @path = File.dirname(__FILE__) + "/../work"
    create_db(@path)
    @kriby_storage = KirbyStorage.new(@path)
  end
  
  def test_retrieves_table_for_instance
    assert_not_nil(@kriby_storage.send(:table_for, Pomodoro.new))
    assert_not_nil(@kriby_storage.send(:table_for, Pomodoro))
  end
  
  def test_creates_a_record
    @kriby_storage.save(Pomodoro.new(:text => "done!"))
    assert_equal(1, @kriby_storage.find_all(Pomodoro).size)
  end
  
  def create_db(path)
    db = KirbyBase.new(:local, nil, nil, path)
    db.drop_table(:pomodoro) if db.table_exists?(:pomodoro)
    pomodoro_tbl = db.create_table(:pomodoro, :text, :String, :timestamp, :Time) { |obj| obj.encrypt = false }
  end
  
  def teardown
    wipe_dir(@path)
  end
        
end