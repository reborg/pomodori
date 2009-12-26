require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/extensions/timestamp'

class TimestampTest < Test::Unit::TestCase
  
  def setup
    @ts = "2009-05-11 18:06:43 -0500"
  end
    
  it "tells if string match time format" do
    @ts.timestamp?.should be(true)
    "2009-05-11 AA:06:43 -0500".timestamp?.should be(false)
    "2009_05_11 11:06:43 -0500".timestamp?.should be(false)
  end
  
  it "extracts the date" do
    @ts.flatten_date.should == "20090511"
    "2009-02-16 05:25:00 +0100".flatten_date.should == "20090216"
  end
  
  it "returns empty string if not ts" do
    "cips".flatten_date.should == ""
  end
  
  it "format the time using same Time convention" do
    time_regexp = /^\d{2}:\d{2}[ap]m$/
    @ts.strftime('%I:%M%p').downcase.should =~ time_regexp
    "2011-01-23 01:24:02 -0700".strftime('%I:%M%p').downcase.should =~ time_regexp
  end
  
end
