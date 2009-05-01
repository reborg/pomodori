require File.dirname(__FILE__) + '/test_helper.rb'

class TestExpectationBuilder < Test::Unit::TestCase
  
  def setup
    @obj = Object.new
  end
  
  def test_should
    exp = Matchy::ExpectationBuilder.build_expectation(true, nil, @obj)
    exp.send(:==, @obj)
  end
  
  def test_should_fails
    expect_1 = Matchy::ExpectationBuilder.build_expectation(true, nil, 1)
    lambda {expect_1.send(:==, 2)}.should raise_error
  end
  
  def test_should_not
    exp = Matchy::ExpectationBuilder.build_expectation(false, nil, @obj)
    exp.send(:==, 1)
  end
  
  def test_should_not_fails
    expect_not_1 = Matchy::ExpectationBuilder.build_expectation(false, nil, 1)
    lambda {expect_not_1.send(:==, 1)}.should raise_error
  end
end