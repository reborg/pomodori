require File.dirname(__FILE__) + '/../test_helper'
require 'tomatoes/storage'
require 'tomatoes/tomato'

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
    assert_match(DateTime.now.strftime("%Y%m%d%H%M"), Dir.entries(@dir)[2])
  end
  
  def test_that_the_serialized_tomato_contains_text
    @storage.save(Tomato.new(:text => "hola"))
    content = ""
    open(@dir + Dir.entries(@dir)[2]).each { |x| content += x}
    assert_match("hola", content)
  end
  
  def teardown
    delete_matching_regexp(@dir)
  end
  
  def count_objects_in(dir)
    return Dir.entries(dir).size
  end
  
  def delete_matching_regexp(dir, regex = /#{DateTime.now.year}/)
	  Dir.entries(dir).each do |name|
	    path = File.join(dir, name)
	    if name =~ regex
	      ftype = File.directory?(path) ? Dir : File
	      begin
	        ftype.delete(path)
	      rescue SystemCallError => e
	        $stderr.puts e.message
	      end
	    end
	  end
	end
  
end
