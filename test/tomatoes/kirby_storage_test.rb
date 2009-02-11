require File.dirname(__FILE__) + '/../test_helper'
require 'thirdparties/kirbybase'
require 'tomatoes/kirby_storage'
require 'tomatoes/tomato'

class KirbyStorageTest < Test::Unit::TestCase
  
  def setup
    @path = File.dirname(__FILE__) + "/../work"
    create_db(@path)
    @kriby_storage = KirbyStorage.new(@path)
  end
  
  def test_retrieves_table_for_instance
    assert_not_nil(@kriby_storage.send(:table_for, Tomato.new))
    assert_not_nil(@kriby_storage.send(:table_for, Tomato))
  end
  
  def test_creates_a_record
    @kriby_storage.save(Tomato.new(:text => "done!"))
    assert_equal(1, @kriby_storage.find_all(Tomato).size)
  end
  
  def create_db(path)
    db = KirbyBase.new(:local, nil, nil, path)
    db.drop_table(:tomato) if db.table_exists?(:tomato)
    tomato_tbl = db.create_table(:tomato, :text, :String, :timestamp, :Time) { |obj| obj.encrypt = false }
  end
  
  def teardown
    wipe_dir(@path)
  end
        
end