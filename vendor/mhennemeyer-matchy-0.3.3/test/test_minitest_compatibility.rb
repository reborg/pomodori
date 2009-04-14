require 'rubygems'
require 'minitest/unit'
FORCE_MINITEST = true
load File.dirname(__FILE__) + '/../lib/matchy.rb'

MiniTest::Unit.autorun

class TestAThing < MiniTest::Unit::TestCase
  def test_equal_equal
    1.should == 1
  end
  
  def test_equal_equal_fails
    #1.should == 2 
    lambda{ 1.should == 2 }.should raise_error
  end
  
  def test_equal_equal_negative
    1.should_not == 2
  end
  
  def test_equal_equal_negative_fails
    lambda{ 1.should_not == 1 }.should raise_error
  end
end