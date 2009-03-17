require 'hotcocoa'

class MainView
  include HotCocoa
  attr_reader :container
  attr_reader :modal_button, :report_button, :timer_label, :summary_label, :pomodoro_icon
  
  def render
    container
  end
  
  def container
    @container ||= window(:frame => [0, 0, 389, 140], :title => "Pomodori", :view => :nolayout) do |win|
      win << pomodoro_icon
      win << summary_label
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
  
  def summary_label
    @summary_label ||= view(:frame => [120, 80, 300, 68]) do |view|
      view << label(      
        :text => "Summary Label", 
        :font => font(:name => "Monaco", :size => 11))
    end
  end
  
  def modal_button
    @modal_button ||= button(
      :title => "Void",
      :frame => [300, 12, 66, 28],
      :bezel => :textured_square, 
      :layout => {:start => false})
  end
  
  def report_button
    @report_button ||= button(
      :title => "Report",
      :frame => [230, 12, 66, 28], 
      :bezel => :textured_square, 
      :layout => {:start => false})
  end
  
  def timer_label
    @timer_label ||= label(
      :frame => [20, 8, 96, 35],
      :text => "24:59",
      :font => font(:name => "Monaco", :size => 26))
  end

end