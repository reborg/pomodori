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
  
  it "extracts the the date" do
    @ts.flatten_date.should == "20090511"
  end
  
  it "returns empty string if not ts" do
    "cips".flatten_date.should == ""
  end
  
  it "format the time using same Time convention" do
    @ts.strftime('%I:%M%p').downcase.should == "06:06pm"
  end
  
end
