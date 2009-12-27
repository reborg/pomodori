Gem::Specification.new do |s|
  s.name     = "matchy"
  s.version  = "0.3.3"
  s.date     = "2009-02-08"
  s.summary  = "RSpec-esque matchers for use in Test::Unit"
  s.email    = "mhennemeyer@gmail.com"
  s.homepage = "http://github.com/mhennemeyer/matchy"
  s.description = "A 300loc refactoring of Jeremy Mcanally's Matchy. Original Description: Hate writing assertions?  Need a little behavior-driven love in your tests?  Then matchy is for you."
  s.has_rdoc = true
  s.authors  = ["Jeremy McAnally", "Matthias Hennemeyer"]
  s.files    = [
    "History.txt", 
  	"Manifest.txt", 
  	"README.rdoc", 
  	"Rakefile", 
  	"matchy.gemspec", 
    "History.txt",
    "License.txt",
    "Manifest.txt",
    "PostInstall.txt",
    "Rakefile",
    "config/hoe.rb",
    "config/requirements.rb",
    "lib/matchy.rb",
    "lib/matchy/version.rb",
    "lib/matchy/expectation_builder.rb",
    "lib/matchy/modals.rb",
    "lib/matchy/def_matcher.rb",
    "lib/matchy/matcher_builder.rb",
    "lib/matchy/built_in/enumerable_expectations.rb",
    "lib/matchy/built_in/error_expectations.rb",
    "lib/matchy/built_in/operator_expectations.rb",
    "lib/matchy/built_in/truth_expectations.rb",
    "lib/matchy/built_in/change_expectations.rb",
    "setup.rb"
  ]
  
  s.test_files = [
    "test/test_change_expectation.rb",
    "test/test_expectation_builder.rb",
    "test/test_minitest_compatibility.rb",
    "test/test_def_matcher.rb",
    "test/test_enumerable_expectations.rb",
    "test/test_error_expectations.rb",
    "test/test_matcher_builder.rb",
    "test/test_operator_expectations.rb",
    "test/test_truth_expectations.rb",
    "test/test_modals.rb"
  ]

  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
end