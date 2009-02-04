require 'hotcocoa'
Dir.glob(File.join(File.dirname(__FILE__), '**/*.rb')).each {|f| require f}

class Application
  attr_accessor :value
  include HotCocoa
  
  def start
    app = application :name => "Hotcocoa", &init 
    app.delegate = self
    app.run
  end
  
  def init
    Proc.new {
      wind = build_window
      wind << build_input_box
      wind << build_buttons_view
    }
  end
  
  def build_window
    win = window(:frame => [380, 615, 389, 140], :title => "Tomato", :view => :nolayout)
    win.will_close { exit }
    win
  end
  
  def build_buttons_view
    buttons_view = view(:frame => [0, 0, 389, 140], :layout => {:border => :line})
    buttons_view << mybutton
    buttons_view
  end
  
  def build_input_box
    @value ||= TextField.new(Frame.new(20, 52, 349, 68)).render
  end
  
  def mybutton
    action = Proc.new do
      tomatoes_controller = TomatoesController.new
      tomatoes_controller.create(:text => @value.to_s)
      exit
    end
    SubmitButton.new(action, Frame.new(279, 4, 96, 32)).render
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