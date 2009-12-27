require File.dirname(__FILE__) + '/test_helper.rb'

class TestMatcherBuilder < Test::Unit::TestCase
  include Matchy::MatcherBuilder

  def setup
    @obj = Object.new
  end
  
  def test_matcher_responds_to_matches
    block = lambda {|given, matcher, args| true}
    build_matcher(:m, &block).should respond_to(:matches?)
  end
  
  def test_fail_positive
    block = lambda {|given, matcher, args| false}
    lambda {@obj.should build_matcher(:m, &block)}.should raise_error
  end
  
  def test_pass_positive
    block = lambda {|given, matcher, args| true}
    @obj.should build_matcher(:m, &block)
  end
  
  def test_fail_negative
    block = lambda {|given, matcher, args| true}
    lambda {@obj.should_not build_matcher(:m, &block)}.should raise_error
  end
  
  def test_pass_negative
    block = lambda {|given, matcher, args| false}
    @obj.should_not build_matcher(:m, &block)
  end
  
  def test_takes_arguments
    block = lambda {|given, matcher, args| $args = args; true}
    @obj.should build_matcher(:m,[1,2,3], &block)
    $args.should eql([1,2,3])
  end
  
  def test_received_method
    block = lambda {|given, matcher, args| $msgs = matcher.msgs; true}
    @obj.should build_matcher(:m, &block).method1
    $msgs[0].name.should eql(:method1)
  end
  
  def test_received_method_takes_args
    block = lambda {|given, matcher, args| $msgs = matcher.msgs; true}
    @obj.should build_matcher(:m, &block).method1(1,2,3)
    $msgs[0].args.should eql([1,2,3])
  end
  
  def test_received_method_takes_block
    block = lambda {|given, matcher, args| $msgs = matcher.msgs; true}
    @obj.should build_matcher(:m, &block).method1 { "Hello, World!"}
    $msgs[0].block.call.should eql("Hello, World!")
  end
  
  def test_received_method_chained
    block = lambda {|given, matcher, args| $msgs = matcher.msgs; true}
    @obj.should build_matcher(:m, &block).method1(1,2,3) { "Hello, World!"}.
      method2(4,5,6) { "Hello chained messages" }
      
    $msgs[0].name.should eql(:method1)
    $msgs[1].name.should eql(:method2)
    $msgs[0].args.should eql([1,2,3])
    $msgs[1].args.should eql([4,5,6])
    $msgs[0].block.call.should eql("Hello, World!")
    $msgs[1].block.call.should eql("Hello chained messages")
  end

end
