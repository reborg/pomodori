require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/summary_widget'
require 'hotcocoa'

class SummaryWidgetTest < Test::Unit::TestCase
  
  def setup
    @summary_widget = SummaryWidget.new
  end

  it "contains 3 rows" do
    @summary_widget.send(:rows).subviews.size.should == 3
  end

  it 'should change the count number' do
    @summary_widget.update_yesterday_count("5")
    @summary_widget.send(:hc_yesterday_count_button).title.should == "5"
  end

  it 'should disappear and then appear again!' do
    @summary_widget.show
    @summary_widget.send(:rows).isHidden.should be(false)
    @summary_widget.hide
    @summary_widget.send(:rows).isHidden.should be(true)
  end

  it 'should initialize with given values' do
    @summary_widget = SummaryWidget.new(
      :yesterday_count => 1,
      :today_count => 2,
      :average_count => 3)
    @summary_widget.send(:hc_yesterday_count_button).title.should == "1"
    @summary_widget.send(:hc_today_count_button).title.should == "2"
    @summary_widget.send(:hc_average_count_button).title.should == "3"
  end

end
