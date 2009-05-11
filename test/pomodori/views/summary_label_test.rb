require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/main_view'

class SummaryLabelTest < Test::Unit::TestCase

  def setup
    controller = stub(
      :yesterday_pomodoros => 10, 
      :today_pomodoros => 5,
      :daily_average => 13)
    @main_view = MainView.new(:pomodori_controller => controller)
  end

  it "shows statistics for break mode" do
    @main_view.expects(:update_window_title).with("Break...")
    @main_view.break_mode
    @main_view.summary_label.to_s.should =~ /10/
  end

  it "shows statistics for running mode" do
    @main_view.expects(:update_window_title).with("Running...")
    @main_view.running_mode
    @main_view.summary_label.to_s.should =~ /5/
  end
  
end