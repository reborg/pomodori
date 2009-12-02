require File.dirname(__FILE__) + '/test_helper.rb'

class TestDefMatcher < Test::Unit::TestCase
  
  def setup 
    @obj = Object.new
  end
    
  def test_defines_method
    def_matcher :method_ do |given, matcher, args|
    end
    self.should respond_to(:method_)
  end
  
  def test_object_responds_to_matches
    def_matcher :method_ do |given, matcher, args|
    end
    method_.should respond_to(:matches?)
  end
  
  def test_fail_positive
    def_matcher :matcher do |given, matcher, args|
      false
    end
    lambda {1.should matcher}.should raise_error
  end
  
  def test_pass_positive
    def_matcher :matcher do |given, matcher, args|
      true
    end
    1.should matcher
  end
  
  def test_fail_negative
    def_matcher :matcher do |given, matcher, args|
      true
    end
    lambda {1.should_not matcher}.should raise_error
  end
  
  def test_pass_negative
    def_matcher :matcher do |given, matcher, args|
      false
    end
    1.should_not matcher
  end
  
  def test_takes_arguments
    def_matcher :matcher do |given, matcher, args|
      $args = args
      true
    end
    @obj.should matcher(1,2,3)
    $args.should eql([1,2,3])
  end
  
  def test_received_method
    def_matcher :matcher do |given, matcher, args|
      $msgs = matcher.msgs
      true
    end
    @obj.should matcher.method1
    $msgs[0].name.should eql(:method1)
  end
  
  def test_received_method_takes_args
    def_matcher :matcher do |given, matcher, args|
      $msgs = matcher.msgs
      true
    end
    @obj.should matcher.method1(1,2,3)
    $msgs[0].args.should eql([1,2,3])
  end
  
  def test_received_method_takes_block
    def_matcher :matcher do |given, matcher, args|
      $msgs = matcher.msgs
      true
    end
    @obj.should matcher.method1 { "Hello, World!"}
    $msgs[0].block.call.should eql("Hello, World!")
  end
  
  def test_received_method_chained
    def_matcher :matcher do |given, matcher, args|
      $msgs = matcher.msgs
      true
    end
    @obj.should matcher.method1(1,2,3) { "Hello, World!"}.
      method2(4,5,6) { "Hello chained messages" }
      
    $msgs[0].name.should eql(:method1)
    $msgs[1].name.should eql(:method2)
    $msgs[0].args.should eql([1,2,3])
    $msgs[1].args.should eql([4,5,6])
    $msgs[0].block.call.should eql("Hello, World!")
    $msgs[1].block.call.should eql("Hello chained messages")
  end
end
