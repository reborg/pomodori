module Matchy
  module Expectations
    module TestCaseExtensions
      # Expects a lambda to raise an error.  You can specify the error or leave it blank to encompass
      # any error.
      #
      # ==== Examples
      #
      #   lambda { raise "FAILURE." }.should raise_error
      #   lambda { puts i_dont_exist }.should raise_error(NameError)
      #
      def raise_error(*obj)
        build_matcher(:raise_error, obj) do |receiver, matcher, args|
          expected = args[0] || Exception
          raised = false
          error = nil
          begin
            receiver.call
          rescue Exception => e
            raised = true
            error = e
          end
          if expected.respond_to?(:ancestors) && expected.ancestors.include?(Exception)
            matcher.positive_msg = "Expected #{receiver.inspect} to raise #{expected.name}, " + 
              (error ? "but #{error.class.name} was raised instead." : "but none was raised.")
            matcher.negative_msg = "Expected #{receiver.inspect} to not raise #{expected.name}."
            comparison = (raised && error.class.ancestors.include?(expected))
          else
            message = error ? error.message : "none"
            matcher.positive_msg = "Expected #{receiver.inspect} to raise error with message matching '#{expected}', but '#{message}' was raised."
            matcher.negative_msg = "Expected #{receiver.inspect} to raise error with message not matching '#{expected}', but '#{message}' was raised."
            comparison = (raised && (expected.kind_of?(Regexp) ? ((error.message =~ expected) ? true : false) : expected == error.message))
          end
          comparison
        end
      end
      
      # Expects a lambda to throw an error.
      #
      # ==== Examples
      #
      #   lambda { throw :thing }.should throw_symbol(:thing)
      #   lambda { "not this time" }.should_not throw_symbol(:hello)
      #
      def throw_symbol(*obj)
        build_matcher(:throw_symbol, obj) do |receiver, matcher, args|
          raised, thrown_symbol, expected = false, nil, args[0]
          begin
            receiver.call
          rescue NameError => e
            raise e unless e.message =~ /uncaught throw/
            raised = true
            thrown_symbol = e.name.to_sym if e.respond_to?(:name)
          rescue ArgumentError => e
            raise e unless e.message =~ /uncaught throw/
            thrown_symbol = e.message.match(/uncaught throw :(.+)/)[1].to_sym
          end
          matcher.positive_msg = "Expected #{receiver.inspect} to throw :#{expected}, but " +
            "#{thrown_symbol ? ':' + thrown_symbol.to_s + ' was thrown instead' : 'no symbol was thrown'}."
          matcher.negative_msg = "Expected #{receiver.inspect} to not throw :#{expected}."
          expected == thrown_symbol
        end
      end      
    end
  end
end