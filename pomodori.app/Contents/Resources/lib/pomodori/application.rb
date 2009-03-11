require 'hotcocoa'
Dir.glob(File.join(File.dirname(__FILE__), '**/*.rb')).each {|f| require f}

class Application
  POMODORO = 25 * 60
  BREAK = 5 * 60
  # POMODORO = 5
  # BREAK = 3
  attr_accessor :input_box, :countdown_field, :main_window
  attr_accessor :bottom_view, :submit_button, :main_app
  attr_accessor :on_click_submit_button, :on_click_void_button, :on_click_stop_button
  
  include HotCocoa
  
  def start
    @main_app = application :name => "Hotcocoa" do |app|
      app.delegate = self
      main_window.will_close { exit }
      main_window << input_box.render
      
      bottom_view << countdown_field.start(POMODORO, method(:on_25_mins_done))
      bottom_view << submit_button.render
      
      main_window << bottom_view
      update_metrics_for_pomodoro
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
    @submit_button ||= SubmitButton.new(
      :action => on_click_void_button, 
      :frame => Frame.new(300, 12, 66, 28),
      :title => "Void")
  end
  
  def pomodori_controller
    @pomodori_controller ||= PomodoriController.new
  end
  
  def on_click_submit_button
    @on_click_submit_button ||= Proc.new do
      pomodori_controller.create(:text => input_box.render.to_s)
      
      update_metrics_for_break
      submit_button.action = on_click_stop_button
      countdown_field.start(BREAK, method(:on_5_mins_done))
    end
  end
  
  def on_click_void_button
    @on_click_void_button ||= Proc.new do
      
      update_metrics_for_break
      submit_button.action = on_click_stop_button
      countdown_field.start(BREAK, method(:on_5_mins_done))
    end
  end
  
  def on_click_stop_button
    @on_click_stop_button ||= Proc.new do
      on_5_mins_done
    end
  end
  
  def on_5_mins_done
    ring
    update_metrics_for_pomodoro
    submit_button.action = on_click_void_button
    countdown_field.start(POMODORO, method(:on_25_mins_done))
  end

  def on_25_mins_done
    ring
    input_box.enable
    submit_button.label = "Submit"
    submit_button.action = on_click_submit_button
  end
  
  def update_metrics_for_break
    input_box.disable(format_metrics("break"))
    submit_button.label = "Restart"
  end
  
  def update_metrics_for_pomodoro
    input_box.disable(format_metrics("pomodoro"))
    submit_button.label = "Void"
  end
  
  def ring
    bell = sound(
      :file => File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation, 'bell.aif'), 
      :by_reference => true)
    bell.play if bell
  end
  
  private
    
    def format_metrics(title)
      "Now running                 #{title.upcase}\n" +
      "Yesterday's pomodoros       #{pomodori_controller.yesterday_pomodoros}\n" +
      "Today's pomodoros so far    #{pomodori_controller.today_pomodoros}"
    end
    
end