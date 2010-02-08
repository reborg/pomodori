require 'pomodori/controllers/modal_button_controller'
require 'pomodori/controllers/timer_controller'
require 'pomodori/controllers/pomodori_controller'
require 'pomodori/controllers/charts_controller'
require 'pomodori/controllers/history_controller'
require 'pomodori/views/chart_view'
require 'pomodori/views/summary_widget'

##
# Main window UI handling
#
class MainView
  include HotCocoa
  
  def initialize(opts = {})
    @modal_button_controller = opts[:modal_button_controller] ||= ModalButtonController.new(:main_view => self)
    @timer_controller = opts[:timer_controller] ||= TimerController.new(:main_view => self)
    @pomodori_controller = opts[:pomodori_controller] ||= PomodoriController.new(:main_view => self)
    @charts_controller = opts[:charts_controller] ||= ChartsController.new
    @history_controller = opts[:history_controller] ||= HistoryController.new
  end

  def render
    hc_main_view
  end
  
  ##
  # Change what the timer label is displaying on screen
  #
  def update_timer(str)
    hc_timer_label.text = str
  end
  
  ##
  # Change the main window title
  #
  def update_window_title(new_title)
    hc_main_view.title = new_title
  end
  
  ##
  # Updates the modal button label
  #
  def update_modal_button_label(label)
    hc_modal_button.title = label
  end
  
  def update_modal_button_action(action)
    hc_modal_button.on_action = action
  end
  
  ##
  # This switches the interface to accept a pomodoro
  #
  # description to be saved
  #
  def submit_mode
    enable_input_box
    hc_modal_button.title = "Submit"
    hc_modal_button.on_action = lambda do |sender|
      @pomodori_controller.create(:text => hc_pomodoro_input_box.to_s)
      @modal_button_controller.on_click_submit(sender)
    end
  end
  
  ##
  # Switches the interface to display statistics and running
  # the timer for a new pomodoro.
  # 
  def running_mode
    update_window_title("#{@pomodori_controller.total_count} pomodoros and counting!")
    disable_input_box
    hc_modal_button.title = "Void"
    hc_modal_button.on_action = @modal_button_controller.method(:on_click_void)
    @timer_controller.on_pomodoro_start
  end
  
  def break_mode
    update_window_title("Break...")
    disable_input_box
    hc_modal_button.title = "Restart"
    hc_modal_button.on_action = @modal_button_controller.method(:on_click_restart)
    @timer_controller.on_break_start
  end
  
  private

    ##
    # Hide the input box and show the summary widget
    #
    def disable_input_box
      hc_pomodoro_input_box.setHidden(true)
      summary_widget.show
      summary_widget.update_yesterday_count(@pomodori_controller.yesterday_pomodoros.size)
      summary_widget.update_today_count(@pomodori_controller.today_pomodoros.size)
      summary_widget.update_average_count(@pomodori_controller.average_pomodoros)
    end
  
    ##
    # Hides the summary widget and shows the input box
    #
    def enable_input_box
      summary_widget.hide
      hc_pomodoro_input_box.setHidden(false)
      hc_pomodoro_input_box.text = @pomodori_controller.last_tags.join(" ") + " "
    end
  
    def hc_main_view
      @hc_main_view ||= window(
        :frame => [0, 0, 389, 140], 
        :title => "Pomodori", 
        :view => :nolayout,
        :style => [:titled, :closable, :miniaturizable, :textured]) do |win|
        win << hc_pomodoro_icon
        win << summary_widget.render
        win << hc_pomodoro_input_box
        win << hc_modal_button
        win << hc_timer_label
      end
    end
    
    def hc_pomodoro_icon
      @hc_pomodoro_icon ||= image_view(
        :frame => [20, 60, 75, 75],
        :file => File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation,'pomodori75.gif'))
    end
    
    def hc_pomodoro_input_box
      @hc_pomodoro_input_box ||= text_field(
        :text => "", 
        :layout => {:start => false}, 
        :frame => [115, 60, 250, 62])
    end
    
    def summary_widget
      @summary_widget ||= SummaryWidget.new(
        :yesterday_count => @pomodori_controller.yesterday_pomodoros,
        :today_count => @pomodori_controller.today_pomodoros,
        :average_count => @pomodori_controller.average_pomodoros,
        :on_click_yesterday => lambda {|sender| @history_controller.on_open_history(:yesterday)},
        :on_click_today => lambda {|sender| @history_controller.on_open_history(:today)},
        :on_click_average => open_chart_action)
    end
    
    ##
    # The action is initialized as part of the connection to
    # the modal_button_controller, no need to do on_action= here
    #
    def hc_modal_button
      @hc_modal_button ||= button(
        :frame => [264, 12, 100, 28],
        :bezel => :textured_square, 
        :layout => {:start => false})
    end
    
    def hc_timer_label
      @hc_timer_label ||= label(
        :frame => [20, 8, 96, 35],
        :text => "25:00",
        :font => font(:name => "Monaco", :size => 26))
    end

    def open_chart_action
      lambda {|sender| @charts_controller.on_open_report}
    end

end
