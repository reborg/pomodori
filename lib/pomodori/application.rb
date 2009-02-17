require 'hotcocoa'
Dir.glob(File.join(File.dirname(__FILE__), '**/*.rb')).each {|f| require f}

class Application
  attr_accessor :input_box, :countdown_field, :main_window
  attr_accessor :bottom_view, :submit_button, :main_app, :on_click_submit_button
  
  include HotCocoa
  
  def start
    @main_app = application :name => "Hotcocoa" do |app|
      app.delegate = self
      main_window.will_close { exit }
      main_window << input_box.render
      
      bottom_view << countdown_field.start(25*60).render
      bottom_view << submit_button.render
      
      main_window << bottom_view
    end
  end
  
  def main_window
    @main_window ||= window(:frame => [380, 615, 389, 140], :title => "Pomodori", :view => :nolayout)
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
      countdown_field.start(5*60, method(:on_5_mins_done))
      input_box.render.text = ""
    end
  end
  
  def on_5_mins_done
    countdown_field.start(25*60)
  end
  
  # file/open
  def on_open(menu)
  end
  
  # file/new 
  def on_new(menu)
  end
  
  # help menu item
  def on_help(menu)
  end
  
  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end
  
  # window/zoom
  def on_zoom(menu)
  end
  
  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end
end