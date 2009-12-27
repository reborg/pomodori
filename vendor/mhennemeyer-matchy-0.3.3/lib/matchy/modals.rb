module Matchy
  module Modals
    # Tests an expectation against the given object.
    #
    # ==== Examples
    # 
    #   "hello".should eql("hello")
    #   13.should equal(13)
    #   lambda { raise "u r doomed" }.should raise_error
    #
    def should(expectation = nil)
      Matchy::ExpectationBuilder.build_expectation(true, expectation, self)
    end
    
    alias :will :should
    
    # Tests that an expectation doesn't match the given object.
    #
    # ==== Examples
    # 
    #   "hello".should_not eql("hi")
    #   41.should_not equal(13)
    #   lambda { "savd bai da bell" }.should_not raise_error
    #
    def should_not(expectation = nil)
      Matchy::ExpectationBuilder.build_expectation(false, expectation, self)
    end
    
    alias :will_not :should_not
    alias :wont :should_not
  end
end

Object.send(:include, Matchy::Modals)