require 'hotcocoa'

class MainView
  include HotCocoa
  attr_reader :bottom_view, :top_view, :main_window, :timer_view
  attr_reader :modal_button, :report_button, :timer_label, :summary_label, :pomodoro_icon_view
  
  def render
    main_window
  end
  
  def main_window
    @main_window ||= window(:frame => [0, 0, 389, 140], :title => "Pomodori") do |win|
      win << bottom_view
      win << top_view
      win << timer_view
    end
  end
  
  def top_view
    @top_right_view ||= layout_view(
      :mode => :horizontal,
      :layout => {:expand => [:width, :height]},
      :margin => 4, :spacing => 2) do |view|
      view << summary_label
    end
  end
  
  def bottom_view
    @bottom_right_view ||= layout_view(
      :mode => :horizontal,
      :layout => {:expand => [:width, :height]},
      :margin => 4, :spacing => 2) do |view|
      view << modal_button
      view << report_button
    end
  end
  
  def timer_view
    @timer_view ||= layout_view(
      :mode => :vertical,
      :layout => {:expand => [:width, :height]},
      :margin => 4, :spacing => 2) do |view|
      view << timer_label
      view << pomodoro_icon_view
    end
  end
    
  def pomodoro_icon_view
    @pomodoro_icon_view ||= image_view(
      :frame => [0,0,60,60],
      :file => File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation,'pomodori.gif'))
  end
  
  def summary_label
    @summary_label ||= label(
      :text => "Summary Label", 
      :font => font(:name => "Monaco", :size => 11))
  end
  
  def modal_button
    @modal_button ||= button(
      :title => "Modal Button",
      :frame => [0, 0, 66, 28],
      :bezel => :textured_square, 
      :layout => {:start => false})
  end
  
  def report_button
    @report_button ||= button(
      :title => "Report Button",
      :frame => [0, 0, 66, 28], 
      :bezel => :textured_square, 
      :layout => {:start => false})
  end
  
  def timer_label
    @timer_label ||= label(
      :text => "Timer Label", 
      :font => font(:name => "Monaco", :size => 16))
  end

end