require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/history_view'
require 'pomodori/models/pomodoro'

class HistoryViewTest < Test::Unit::TestCase

  def setup
    @history_view = HistoryView.new()
  end

  it "should format time for table cell" do
    @history_view.format_time(DateTime.now).should =~ /^[0-9]{2}:[0-9]{2}am|pm$/
  end
  
  it "should arrange sentence for given lenght" do
    txt = "pomodori yestpomo"
    @history_view.smart_split(txt, 30).should == txt
    @history_view.smart_split(txt, 10).should == "pomodori\nyestpomo"
    @history_view.smart_split(txt, 8).should == "pomodori\nyestpomo"
  end
  
  it "should hashify pomodoro" do
    pomo = Pomodoro.new(:text => "descr", :timestamp => Time.now)
    @history_view.hashify([pomo]).first.should respond_to(:keys)
  end
  
  it "copies data in the hashified pomodoro" do
    pomo = Pomodoro.new(:text => "descr", :timestamp => Time.now)
    @history_view.hashify([pomo]).first[:text].should_not be(nil)
    @history_view.hashify([pomo]).first[:timestamp].should_not be(nil)
  end
  
  it "processes data for hashified pomodoro" do
    txt = "if descr is longer than 50 chars should be split into multiline"
    pomo = Pomodoro.new(:text => txt, :timestamp => DateTime.new(2009,10,10,13,55))
    @history_view.hashify([pomo]).first[:timestamp].should == "01:55pm"
    txt_trimmed = "if descr is longer than 50 chars should be split\n"
    @history_view.hashify([pomo]).first[:text].should =~ /#{txt_trimmed}/
  end
  
  it "hashifies an array of pomodoros into an array of hashes" do
    @history_view.hashify(pomodoros(5)).size.should == 5
    @history_view.hashify(pomodoros(5)).first.should respond_to(:keys)
  end
  
  it 'closes the window on close button' do
    hc_history_window = mock()
    @history_view.expects(:hc_history_window).returns(hc_history_window)
    hc_history_window.expects(:close)
    @history_view.send(:close_window_action).call("me")
  end
  
end
