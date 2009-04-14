module Matchy
  module DefMatcher
    include Matchy::MatcherBuilder
    def def_matcher(matcher_name, &block)
      self.class.send :define_method, matcher_name do |*args|
        build_matcher(matcher_name, args, &block)
      end
    end
  end
end
