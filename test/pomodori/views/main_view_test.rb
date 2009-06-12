require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/main_view'

class MainViewTest < Test::Unit::TestCase
  attr_accessor :called
  
  def setup
    @modal_button_controller = mock("modal_button_controller")
    @modal_button_controller.class.send(:define_method, :on_click_void, lambda{})
    @modal_button_controller.class.send(:define_method, :on_click_submit, lambda{})
    @modal_button_controller.class.send(:define_method, :on_click_restart, lambda{})
    @main_view = MainView.new(
      :modal_button_controller => @modal_button_controller,
      :timer_controller => stub_everything,
      :pomodori_controller => stub_everything(
        :yesterday_pomodoros => ["y"]*10, 
        :today_pomodoros => ["t"]*5,
        :total_count => 190,
        :last_tags => ["@some", "@tag"]))
  end
  
  it "changes the timer label" do
    @main_view.update_timer("hey")
    @main_view.send(:hc_timer_label).to_s.should == "hey"
  end
  
  it "switches off the text area and show the summary" do
    @main_view.send(:disable_input_box)
    @main_view.send(:summary_widget).render.hidden?.should be(false)
    @main_view.send(:hc_pomodoro_input_box).hidden?.should be(true)
  end
  
  it "display statistics when summary widget is visible" do
    @main_view.send(:disable_input_box)
    @main_view.send(:summary_widget).send(:hc_yesterday_count_button).title.should == "10"
  end
  
  it "switches on the input box and hide the summary for editing" do
    @main_view.send(:enable_input_box)
    @main_view.send(:summary_widget).render.hidden?.should be(true)
    @main_view.send(:hc_pomodoro_input_box).hidden?.should be(false)
    @main_view.send(:hc_pomodoro_input_box).to_s.should == "@some @tag "
  end
  
  it "enable input box when going submit mode" do
    @main_view.expects(:enable_input_box)
    @main_view.submit_mode
    @main_view.send(:hc_modal_button).title.should == "Submit"
  end
  
  it "changes the modal label" do
    @main_view.update_modal_button_label("cips")
    @main_view.send(:hc_modal_button).title.should == "cips"
  end
  
  it "shows statistics for break mode" do
    @main_view.expects(:update_window_title).with("Break...")
    @main_view.break_mode
    @main_view.send(:summary_widget).send(:hc_yesterday_count_button).title.should == "10"
  end

  it "shows statistics for running mode" do
    @main_view.expects(:update_window_title)
    @main_view.running_mode
    @main_view.send(:summary_widget).send(:hc_today_count_button).title.should == "5"
  end

  it 'shows total count on window bar on running mode' do
    @main_view.expects(:update_window_title).with("190 pomodoros and counting!")
    @main_view.running_mode
  end
  
end
