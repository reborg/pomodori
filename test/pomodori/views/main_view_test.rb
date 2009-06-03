require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/views/main_view'

class MainViewTest < Test::Unit::TestCase
  attr_accessor :called
  
  def setup
    @modal_button_controller = mock("modal_button_controller")
    @modal_button_controller.class.send(:define_method, :on_click_void, lambda{})
    @modal_button_controller.class.send(:define_method, :on_click_submit, lambda{})
    @main_view = MainView.new(
      :modal_button_controller => @modal_button_controller,
      :timer_controller => stub_everything,
      :pomodori_controller => stub_everything(:last_tags => ["@some", "@tag"]))
  end
  
  it "changes the timer label" do
    @main_view.update_timer("hey")
    @main_view.timer_label.to_s.should == "hey"
  end
  
  it "switches off the input box" do
    @main_view.send(:disable_input_box)
    @main_view.summary_label.editable?.should == false
  end
  
  it "switches off the input box with a message" do
    @main_view.send(:disable_input_box, "good")
    @main_view.summary_label.to_s.should == "good"
  end
  
  it "switches on the input box for editing" do
    @main_view.send(:enable_input_box)
    @main_view.summary_label.editable?.should == true
    @main_view.summary_label.to_s.should == "@some @tag "
  end
  
  it "enable input box when going submit mode" do
    @main_view.expects(:enable_input_box)
    @main_view.submit_mode
    @main_view.modal_button.title.should == "Submit"
  end
  
  it "changes the modal label" do
    @main_view.update_modal_button_label("cips")
    @main_view.modal_button.title.should == "cips"
  end
  
end
