$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# Matchy should work with either test/unit 
# or minitest
module Matchy
  def self.minitest?
    # This needs to be better.
    # How can we decide if we really have a 
    # suite of MiniTest Tests?
    # Rails for example defines MiniTest, so to only check for
    # defined?(MiniTest) would be malicious
    defined?(FORCE_MINITEST) || defined?(MiniTest) && defined?(MiniTest::Assertions) && 
      (!defined?(Test::Unit::TestCase) || (Test::Unit::TestCase < MiniTest::Assertions))
  end
  
  def self.assertions_module
    minitest? ? MiniTest::Assertions : Test::Unit::Assertions
  end
  
  def self.test_case_class
    minitest? ? MiniTest::Unit::TestCase : Test::Unit::TestCase
  end
end

require 'rubygems'
require 'test/unit' unless Matchy.minitest?

require 'matchy/expectation_builder'
require 'matchy/modals'
require 'matchy/version'
require 'matchy/matcher_builder'
require 'matchy/def_matcher'

require 'matchy/built_in/enumerable_expectations'
require 'matchy/built_in/error_expectations'
require 'matchy/built_in/truth_expectations'
require 'matchy/built_in/operator_expectations'
require 'matchy/built_in/change_expectations'


# Hack of Evil.
# Track the current testcase and 
# provide it to the operator matchers.
Matchy.test_case_class.class_eval do
  alias_method :old_run_method_aliased_by_matchy, :run
  def run(whatever, *args, &block)
    $current_test_case = self
    old_run_method_aliased_by_matchy(whatever, *args, &block)
  end
end

Matchy.test_case_class.send(:include, Matchy::Expectations::TestCaseExtensions)

include Matchy::DefMatcher

