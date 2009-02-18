require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'
Dir.glob(File.join(File.dirname(__FILE__), 'pomodori/*_test.rb')).each {|f| require f}

class AllTests
  def self.suite
    suite = Test::Unit::TestSuite.new
    suite << FrameTest.suite
    suite << StorageTest.suite
    suite << SubmitButtonTest.suite
    suite << TextFieldTest.suite
    suite << PomodoroTest.suite
    suite << PomodoriControllerTest.suite
    suite << KirbyStorageTest.suite
    suite << CountdownTest.suite
    suite << CountdownCallbackTest.suite
    suite << CountdownFieldTest.suite
    suite << CountdownFieldTimerTest.suite
    suite << ApplicationTest.suite
    suite << On25MinsTimerTest.suite
    suite << OnClickTheSubmitButtonTest.suite
    return suite
  end
end
