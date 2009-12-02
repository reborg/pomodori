module Matchy
  module Expectations 
    module TestCaseExtensions
      
      # Calls +include?+ on the receiver for any object.  You can also provide
      # multiple arguments to see if all of them are included.
      #
      # ==== Examples
      #   
      #   [1,2,3].should include(1)
      #   [7,8,8].should_not include(3)
      #   ['a', 'b', 'c'].should include('a', 'c')
      #
      def include(*obj)
        _clude(:include, obj)
      end
      
      # Expects the receiver to exclude the given object(s). You can provide
      # multiple arguments to see if all of them are included.
      #
      # ==== Examples
      #   
      #   [1,2,3].should exclude(16)
      #   [7,8,8].should_not exclude(7)
      #   ['a', 'b', 'c'].should exclude('e', 'f', 'g')
      #
      def exclude(*obj)
        _clude(:exclude, obj)
      end
      
      private
      def _clude(sym, obj)
        build_matcher(sym, obj) do |given, matcher, args|
          matcher.positive_msg = "Expected #{given.inspect} to #{sym} #{args.inspect}."
          matcher.negative_msg = "Expected #{given.inspect} to not #{sym} #{args.inspect}."
          args.inject(true) {|m,o| m && (given.include?(o) == (sym == :include)) }
        end
      end
    end
  end
end