require File.dirname(__FILE__) + '/../test_helper'
require 'pomodoro'

class PomodoroTest < Test::Unit::TestCase
  
  def setup
    @pomodoro = Pomodoro.new
  end
  
  it 'initializes with timestamps' do
    now = "2009-05-11 18:06:43 -0500"
    pomodoro = Pomodoro.new({:text => "hola", :timestamp => now})
    pomodoro.text.should =~ /hola/
    now.should == pomodoro.timestamp
  end
  
  it 'has default timestamp' do
    @pomodoro.timestamp.should_not == nil
  end

  it 'should extract tags from the description' do
    pomodoro = Pomodoro.new(:text => "@at @cips urban @nop")
    pomodoro.tags.size.should == 3
    pomodoro.tags.should include("@nop") 
  end

  it 'should store in the pstore' do
    require 'pstore'
    pomodoro = Pomodoro.new(:text => "@at @cips urban @nop", :timestamp => DateTime.now)
    pstore = PStore.new("/tmp/pomostore.pstore")
    pstore.transaction do
      pstore[:pomo] = [pomodoro]
    end
  end
  
end
