require File.dirname(__FILE__) + '/test_helper.rb'

class TestModals < Test::Unit::TestCase
  def setup
    @expectation = build_matcher() {|r,m,a| true}
    @bad_expectation = build_matcher() {|r,m,a| false}
  end
  
  def test_should
    3.should(@expectation)
  end
  
  def test_will
    3.will(@expectation)
  end
  
  def test_should_not
    3.should_not(@bad_expectation)
  end
  
  def test_will_not
    3.will_not(@bad_expectation)
  end
  
  def test_wont
    3.wont(@bad_expectation)
  end
  
  def test_should_operator_expectation_returned
    obj = 3.should
    assert_equal Matchy::Expectations::OperatorExpectation, obj.class
  end
  
  
  def test_should_not_operator_expectation_returned
    obj = 3.should_not
    assert_equal Matchy::Expectations::OperatorExpectation, obj.class
  end
end
