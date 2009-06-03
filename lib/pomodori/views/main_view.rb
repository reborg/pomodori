require 'hotcocoa'
require 'pomodori/controllers/modal_button_controller'
require 'pomodori/controllers/timer_controller'
require 'pomodori/controllers/pomodori_controller'
require 'pomodori/controllers/charts_controller'
require 'pomodori/views/chart_view'

##
# Main window UI handling
#
class MainView
  include HotCocoa
  attr_reader :container, :summary_label_view, :modal_button_controller
  attr_reader :modal_button, :report_button, :timer_label, :summary_label, :pomodoro_icon
  
  def initialize(opts = {})
    @modal_button_controller = opts[:modal_button_controller] ||= ModalButtonController.new(:main_view => self)
    @timer_controller = opts[:timer_controller] ||= TimerController.new(:main_view => self)
    @pomodori_controller = opts[:pomodori_controller] ||= PomodoriController.new(:main_view => self)
    @charts_controller = opts[:charts_controller] ||= ChartsController.new
  end

  def render
    container
  end
  
  def container
    @container ||= window(
      :frame => [0, 0, 389, 140], 
      :title => "Pomodori", 
      :view => :nolayout,
      :style => [:titled, :closable, :miniaturizable, :textured]) do |win|
      win << pomodoro_icon
      win << summary_label_view
      win << modal_button
      win << report_button
      win << timer_label
    end
  end
  
  def pomodoro_icon
    @pomodoro_icon ||= image_view(
      :frame => [20, 60, 75, 75],
      :file => File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation,'pomodori75.gif'))
  end
  
  def summary_label_view
    @summary_label_view ||= view(:frame => [115, 60, 250, 62]) do |view|
      view << summary_label
    end
  end
  
  def summary_label
    @summary_label ||= label(
      :frame => [0, 0, 250, 62],
      :font => font(:name => "Andale Mono", :size => 12))
  end
  
  ##
  # The action is initialized as part of the connection to
  # the modal_button_controller, no need to do on_action= here
  #
  def modal_button
    @modal_button ||= button(
      :frame => [300, 12, 66, 28],
      :bezel => :textured_square, 
      :layout => {:start => false})
  end
  
  def report_button
    @report_button ||= button(
      :title => "Report",
      :frame => [230, 12, 66, 28], 
      :bezel => :textured_square, 
      :layout => {:start => false},
      :on_action => lambda {|sender| @charts_controller.on_open_report })
  end
  
  def timer_label
    @timer_label ||= label(
      :frame => [20, 8, 96, 35],
      :text => "25:00",
      :font => font(:name => "Monaco", :size => 26))
  end
  
  ### SERVICES ###
  
  ##
  # Change what the timer label is displaying on screen
  #
  def update_timer(str)
    timer_label.text = str
  end
  
  ##
  # Change the main window title
  #
  def update_window_title(new_title)
    container.title = new_title
  end
  
  ##
  # Updates the modal button label
  #
  def update_modal_button_label(label)
    modal_button.title = label
  end
  
  def update_modal_button_action(action)
    modal_button.on_action = action
  end
  
  ##
  # This switches the interface to accept a pomodoro
  # description to be saved
  #
  def submit_mode
    enable_input_box
    modal_button.title = "Submit"
    modal_button.on_action = lambda do |sender|
      @pomodori_controller.create(:text => summary_label.to_s)
      @modal_button_controller.on_click_submit(sender)
    end
  end
  
  ##
  # Switches the interface to display statistics and running
  # the timer for a new pomodoro.
  # 
  def running_mode
    update_window_title("Running...")
    disable_input_box(format_metrics)
    modal_button.title = "Void"
    modal_button.on_action = @modal_button_controller.method(:on_click_void)
    @timer_controller.on_pomodoro_start
  end
  
  def break_mode
    update_window_title("Break...")
    disable_input_box(format_metrics)
    modal_button.title = "Restart"
    modal_button.on_action = @modal_button_controller.method(:on_click_restart)
    @timer_controller.on_break_start
  end
  
  private

    def format_metrics
      "Yesterday:  #{@pomodori_controller.yesterday_pomodoros}\n" +
      "Today:      #{@pomodori_controller.today_pomodoros}\n" +
      "Average:    #{@pomodori_controller.daily_average}"
    end
  
    ##
    # Change the behavior of the input box to be just
    # a not editable label.
    #
    def disable_input_box(message = "")
      # FIXME: touching alignment is the only way I found
      # to change also the rest of the properties.
      summary_label.text_align = NSCenterTextAlignment
      summary_label.text_align = NSLeftTextAlignment
      summary_label.setDrawsBackground(false)
      summary_label.setBordered(false)
      summary_label.setSelectable(false)
      summary_label.editable = false
      summary_label.text = message
    end
  
    ##
    # Change the summary label to an empty and editable
    # input text box.
    #
    def enable_input_box
      summary_label.setDrawsBackground(true)
      summary_label.setBordered(true)
      summary_label.setSelectable(true)
      summary_label.editable = true
      summary_label.text = @pomodori_controller.last_tags.join(" ") + " "
    end
  
end
