require 'hotcocoa'
framework 'webkit'

##
# UI components for the chart view.
#
class ChartView
  include HotCocoa
  attr_reader :top_view, :bottom_view, :reload_button, :close_button, :browser, :chart_window
  ALL_TAGS_REPORT = File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation, 'resources/all_tags_report.html')
  
  def render
    chart_window
  end
  
  def chart_window
    @chart_window ||= window(:frame => [100, 100, 700, 500], :title => "Reports") do |win|
      win << bottom_view
      win << top_view
    end
  end
  
  def top_view
    @top_view ||= layout_view(
      # :frame => [0, 50, 700, 450],
      :mode => :horizontal,
      :layout => {:expand => [:width, :height]},
      :margin => 4, :spacing => 0) do |view|
      view << browser
    end
  end
  
  def bottom_view
    @bottom_view ||= layout_view(
      :mode => :horizontal,
      :layout => {:expand => [:width, :height]}) do |view|
      view << reload_button
      view << close_button      
    end
  end
  
  def reload_button
    @reload_button ||= button(
        :title => "Reload",
        :bezel => :textured_square,
        :frame => [525, 12, 66, 28],
        :on_action => Proc.new {})
  end
  
  def close_button
    @close_button ||= button(
        :title => "Close",
        :bezel => :textured_square,
        :frame => [600, 12, 66, 28],
        :on_action => Proc.new {@chart_window.close})
  end
  
  def browser
    @browser ||= web_view(
      :layout => {:expand =>  [:width, :height]}, 
      :url => NSURL.alloc.initFileURLWithPath(ALL_TAGS_REPORT))
  end
  
end