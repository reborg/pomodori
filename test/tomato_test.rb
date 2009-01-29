require File.dirname(__FILE__) + '/test_helper'

class TomatoTest < Test::Unit::TestCase
  
  def setup
    @tomato = Tomato.new
  end
  
  def test_intializes_with_arg_hash
    tomato = Tomato.new({:text => "hola"})
    assert_equal("hola", tomato.text)
  end
  
end
