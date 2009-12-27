module Matchy
  module Expectations
    module TestCaseExtensions
      # Simply checks if the receiver matches the expected object.
      # TODO: Fill this out to implement much of the RSpec functionality (and then some)
      #
      # ==== Examples
      #
      #   "hello".should be("hello")
      #   (13 < 20).should be(true)
      #
      def be(*obj)
        build_matcher(:be, obj) do |receiver, matcher, args|
          @receiver, expected = receiver, args[0]
          matcher.positive_msg = "Expected #{@receiver.inspect} to be #{expected.inspect}."
          matcher.negative_msg = "Expected #{@receiver.inspect} to not be #{expected.inspect}."
          expected == @receiver
        end
      end
      
      # Checks if the given object is within a given object and delta.
      #
      # ==== Examples
      #
      #   (20.0 - 2.0).should be_close(18.0)
      #   (13.0 - 4.0).should be_close(9.0, 0.5)
      #
      def be_close(obj, delta = 0.3)
        build_matcher(:be_close, [obj, delta]) do |receiver, matcher, args|
          @receiver, expected, delta = receiver, args[0], args[1]
          matcher.positive_msg = "Expected #{@receiver.inspect} to be close to #{expected.inspect} (delta: #{delta})."
          matcher.negative_msg = "Expected #{@receiver.inspect} to not be close to #{expected.inspect} (delta: #{delta})."
          (@receiver - expected).abs < delta
        end
      end
      
      # Calls +exist?+ on the given object.
      #
      # ==== Examples
      #
      #   # found_user.exist?
      #   found_user.should exist
      #
      def exist
        ask_for(:exist, :with_arg => nil)
      end   
      
      # Calls +eql?+ on the given object (i.e., are the objects the same value?)
      #
      # ==== Examples
      #   
      #    1.should_not eql(1.0)
      #    (12 / 6).should eql(6)
      #
      def eql(*obj)
        ask_for(:eql, :with_arg => obj)
      end
      
      # Calls +equal?+ on the given object (i.e., do the two objects have the same +object_id+?)
      #
      # ==== Examples
      # 
      #   x = [1,2,3]
      #   y = [1,2,3]
      #
      #   # Different object_id's...
      #   x.should_not equal(y)
      #
      #   # The same object_id
      #   x[0].should equal(y[0])
      #
      def equal(*obj)
        ask_for(:equal, :with_arg => obj)
      end
      
      # A last ditch way to implement your testing logic.  You probably shouldn't use this unless you
      # have to.
      #
      # ==== Examples
      #
      #   (13 - 4).should satisfy(lambda {|i| i < 20})
      #   "hello".should_not satisfy(lambda {|s| s =~ /hi/})
      #
      def satisfy(*obj)
        build_matcher(:satisfy, obj) do |receiver, matcher, args|
          @receiver, expected = receiver, args[0]
          matcher.positive_msg = "Expected #{@receiver.inspect} to satisfy given block."
          matcher.negative_msg = "Expected #{@receiver.inspect} to not satisfy given block."
          expected.call(@receiver) == true
        end
      end
      
      # Checks if the given object responds to the given method
      #
      # ==== Examples
      #
      #   "foo".should respond_to(:length)
      #   {}.should respond_to(:has_key?)
      def respond_to(*meth)
        ask_for(:respond_to, :with_arg => meth)
      end
      
      # Asks given for success?().
      # This is necessary because Rails Integration::Session
      # overides method_missing without grace.
      #
      # ==== Examples
      #
      #   @response.should be_success
      def be_success
        ask_for(:success, :with_arg => nil)
      end

      alias_method :old_missing, :method_missing
      # ==be_*something(*args)
      #
      # ===This method_missing acts as a matcher builder. 
      # If a call to be_xyz() reaches this method_missing (say: obj.should be_xyz), 
      # a matcher with the name xyz will be built, whose defining property
      # is that it returns the value of obj.xyz? for matches?.
      # ==== Examples
      #
      #   nil.should be_nil
      #   17.should be_kind_of(Fixnum)
      #   obj.something? #=> true
      #   obj.should be_something
      def method_missing(name, *args, &block)
        if (name.to_s =~ /^be_(.+)/)
          ask_for($1, :with_arg => args)
        else
          old_missing(name, *args, &block)
        end
      end
      
    private
      def ask_for(sym, option={})
        build_matcher(sym, (option[:with_arg] || [])) do |receiver, matcher, args|
          expected, meth = args[0], (sym.to_s + "?" ).to_sym
          matcher.positive_msg = "Expected #{receiver.inspect} to return true for #{sym}?, with '#{(expected && expected.inspect) || 'no args'}'."
          matcher.negative_msg = "Expected #{receiver.inspect} to not return true for #{sym}?, with '#{(expected && expected.inspect) || 'no args'}'."
          expected ? receiver.send(meth, expected) : receiver.send(meth)
        end
      end
    end
  end
end