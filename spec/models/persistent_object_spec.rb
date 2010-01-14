require File.dirname(__FILE__) + "/../spec_helper"
require 'models/persistent_object'
require 'models/pomodoro'
require 'models/persistence'

class PersistentObjectSpec < Test::Unit::TestCase

  def setup
    setup_persistence
    @pomodoro = Pomodoro.new
  end

  it 'should intercept new and return a managed entity' do
    @pomodoro.entity.name.should == "Pomodoro"
  end

  it 'is stored in the database' do
    @pomodoro.text = "Test"
    @pomodoro.save
    Pomodoro.find_by_text("Test").should_not be_nil
  end

  it 'retrieve the count of created entities' do
    Pomodoro.all.each {|p| puts p.description}
    2.times {|i| Pomodoro.create!(:text => "Hi #{i}", :timestamp => NSDate.date) }
    Pomodoro.count.should == 2 # FAIL! a 3rd one is created somehow
  end

  def teardown
    teardown_persistence
  end

end
