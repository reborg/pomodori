require File.dirname(__FILE__) + '/../test_helper'
require 'pomodori/storage'
require 'pomodori/models/pomodoro'

class StorageTest < Test::Unit::TestCase
  
  def setup
    @dir = File.dirname(__FILE__) + "/../work/"
    @storage = Storage.new(@dir)
  end
  
  def test_that_it_uses_current_dir_as_default
    storage = Storage.new
    assert_not_nil(storage.path)
  end
  
  def test_that_it_produces_a_file
    count_before = count_objects_in(@dir)
    @storage.save("this")
    assert_equal(count_before + 1, count_objects_in(@dir))
  end  
  
  def test_that_it_creates_a_timestamp
    ts = @storage.timestamp
    day = "#{DateTime.now.day}"
    assert_match(day, ts)
    assert_equal(14, ts.size)
  end

  def test_that_the_file_name_is_a_timestamp
    @storage.save("this")    
    assert_match(DateTime.now.strftime("%Y%m%d%H%M"), get_file_by_index(@dir, 1))
  end
  
  def test_that_the_serialized_pomodoro_contains_text
    @storage.save(Pomodoro.new(:text => "hola"))
    content = ""
    open(@dir + get_file_by_index(@dir, 1)).each { |x| content += x}
    assert_match("hola", content)
  end
  
  def teardown
    wipe_dir(@dir, /#{DateTime.now.year}/)
  end
  
  def count_objects_in(dir)
    return Dir.entries(dir).size - 1 # remove .gitignore
  end
  
  # [0] => . [1] => .. [2] => .gitignore
  def get_file_by_index(path, i)
    Dir.entries(path)[2+i]
  end
  
end
