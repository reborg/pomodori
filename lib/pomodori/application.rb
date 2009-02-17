require 'hotcocoa'
Dir.glob(File.join(File.dirname(__FILE__), '**/*.rb')).each {|f| require f}

class Application
  # POMODORO = 25 * 60
  # BREAK = 5 * 60
  POMODORO = 5
  BREAK = 2
  attr_accessor :input_box, :countdown_field, :main_window
  attr_accessor :bottom_view, :submit_button, :main_app, :on_click_submit_button
  
  include HotCocoa
  
  def start
    @main_app = application :name => "Hotcocoa" do |app|
      app.delegate = self
      main_window.will_close { exit }
      main_window << input_box.disable
      
      bottom_view << countdown_field.start(POMODORO, method(:on_25_mins_done))
      bottom_view << submit_button.render
      
      main_window << bottom_view
    end
  end
  
  def main_window
    @main_window ||= window(:frame => [0, 0, 389, 140], :title => "Pomodori", :view => :nolayout)
  end

  def input_box
    @input_box ||= TextField.new(Frame.new(20, 52, 349, 68))
  end
  
  def bottom_view
    @bottom_view ||= view(:frame => [0, 0, 389, 140], :layout => {:border => :line})
  end
  
  def countdown_field
    @countdown_field ||= CountdownField.new(:frame => Frame.new(20, 8, 96, 35))
  end
    
  def submit_button
    @submit_button ||= SubmitButton.new(on_click_submit_button, Frame.new(279, 4, 96, 32))
  end
  
  def pomodori_controller
    @pomodori_controller ||= PomodoriController.new
  end
  
  def on_click_submit_button
    @on_click_submit_button ||= Proc.new do
      pomodori_controller.create(:text => input_box.render.to_s)
      countdown_field.start(BREAK, method(:on_5_mins_done))
      input_box.render.text = ""
    end
  end
  
  def on_5_mins_done
    ring
    input_box.disable
    countdown_field.start(POMODORO, method(:on_25_mins_done))
  end

  def on_25_mins_done
    ring
    input_box.enable
  end
  
  def ring
    bell = sound(
      :file => File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation, 'bell.aif'), 
      :by_reference => true)
    bell.play if bell
  end
    
end