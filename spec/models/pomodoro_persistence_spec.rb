require File.dirname(__FILE__) + '/../spec_helper'
require 'pomodoro'
framework 'coredata'

class PomodoroPersistenceSpec < Test::Unit::TestCase
  it 'retrieve the count of saved pomodoros' do
    Persistence.stubs(:object_model_from_bundle).returns(test_mom)
    Pomodoro.count.should == 59
  end
end

def test_mom
  bundle = NSBundle.bundleWithPath(File.dirname(__FILE__) + "/../test_mom") 
  NSManagedObjectModel.mergedModelFromBundles([bundle])
end
