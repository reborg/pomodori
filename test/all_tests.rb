require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'
Dir.glob(File.join(File.dirname(__FILE__), 'tomatoes/*_test.rb')).each {|f| require f}

class AllTests
  def self.suite
    suite = Test::Unit::TestSuite.new
    suite << FrameTest.suite
    suite << StorageTest.suite
    suite << SubmitButtonTest.suite
    suite << TextFieldTest.suite
    suite << TomatoTest.suite
    suite << TomatoesControllerTest.suite
    suite << KirbyStorageTest.suite
    suite << CountdownTest.suite
    suite << CountdownCallbackTest.suite
    suite << CountdownFieldTest.suite
    suite << CountdownFieldTimerTest.suite
    return suite
  end
end
