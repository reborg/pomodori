require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/summary_widget'
require 'hotcocoa'

class SummaryWidgetTest < Test::Unit::TestCase
  
  def setup
    @summary_widget = SummaryWidget.new(
      :yesterday_count => 10, 
      :today_count => 11, 
      :average_count => 12)
  end
  
  it "contains 3 rows" do
    @summary_widget.rows.subviews.size.should == 3
  end

end
