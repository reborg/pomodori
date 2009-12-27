require File.dirname(__FILE__) + '/../test_helper'
require 'pomodoro'
framework 'coredata'

class PomodoroPersistenceTest < Test::Unit::TestCase
  it 'retrieve the count of saved pomodoros' do
    Persistence.stubs(:object_model_from_bundle).returns(mom)
    Pomodoro.count.should == 15
  end
end

def mom
  bundle = NSBundle.bundleWithPath(APP_ROOT + "/build/Debug/#{APP_NAME}.app/") 
  NSManagedObjectModel.mergedModelFromBundles([bundle])
end
