require File.dirname(__FILE__) + "/../spec_helper"
require 'models/persistent_object'
require 'models/pomodoro'
require 'models/persistence'

class PersistentObjectSpec < Test::Unit::TestCase

  def setup
    setup_persistence
  end

  it 'should intercept new and return a managed entity' do
    @pomodoro = Pomodoro.new(:text => "Main Test Pomo")
    @pomodoro.entity.name.should == "Pomodoro"
  end

  it 'is stored in the database' do
    @pomodoro = Pomodoro.new
    @pomodoro.text = "Test"
    @pomodoro.save
    Pomodoro.find_by_text("Test").should_not be_nil
  end

  it 'retrieve the count of created entities' do
    2.times {|i| Pomodoro.create!(:text => "Hi #{i}", :timestamp => NSDate.date) }
    Pomodoro.count.should == 2
  end

  def teardown
    teardown_persistence
  end

end
