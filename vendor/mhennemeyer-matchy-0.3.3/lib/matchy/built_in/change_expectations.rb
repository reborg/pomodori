module Matchy
  module Expectations
    module TestCaseExtensions
      # Checks if the given block alters the value of the block attached to change
      #
      # ==== Examples
      #   lambda {var += 1}.should change {var}.by(1)
      #   lambda {var += 2}.should change {var}.by_at_least(1)
      #   lambda {var += 1}.should change {var}.by_at_most(1)
      #   lambda {var += 2}.should change {var}.from(1).to(3) if var = 1
      def change(&block)
        build_matcher(:change) do |receiver, matcher, args|
          before, done, after = block.call, receiver.call, block.call
          comparison = after != before
          if list = matcher.msgs
            comparison = case list[0].name
              # todo: provide meaningful messages
            when :by          then (after == before + list[0].args[0] || after == before - list[0].args[0])
            when :by_at_least then (after >= before + list[0].args[0] || after <= before - list[0].args[0])
            when :by_at_most  then (after <= before + list[0].args[0] && after >= before - list[0].args[0])
            when :from        then (before == list[0].args[0]) && (after == list[1].args[0])
            end
          end
          matcher.positive_msg = "given block shouldn't alter the block attached to change"
          matcher.negative_msg = "given block should alter the block attached to change"
          comparison
        end
      end
    end
  end
end