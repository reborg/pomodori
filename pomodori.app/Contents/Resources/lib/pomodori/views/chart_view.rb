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
      win << top_view
      win << bottom_view
    end
  end
  
  ##
  # FIXME: I suspect the expansion is not working in MacRuby 0.3
  # try again on 0.4
  #
  def top_view
    @top_view ||= layout_view(
      :frame => [0, 50, 700, 450], 
      # :layout => {:expand => [:width, :height]},
      :margin => 4, :spacing => 4) do |view|
      view << browser
    end
  end
  
  def bottom_view
    @bottom_view ||= layout_view(
      :mode => :horizontal, 
      :frame => [0, 0, 700, 50]) do |view|
      view << reload_button
      view << close_button      
    end
  end
  
  def reload_button
    @reload_button ||= button(
        :title => "Reload",
        :bezel => :textured_square,
        :frame => [525, 12, 66, 28], 
        :layout => {:expand => :width, :start => false}, 
        :on_action => Proc.new {})
  end
  
  def close_button
    @close_button ||= button(
        :title => "Close",
        :bezel => :textured_square,
        :frame => [600, 12, 66, 28],
        :layout => {:expand => :width, :start => false}, 
        :on_action => Proc.new {@chart_window.close})
  end
  
  def browser
    @browser ||= web_view(
      :frame => [0, 0, 700, 450], 
      # :layout => {:expand =>  [:width, :height]}, 
      :url => NSURL.alloc.initFileURLWithPath(ALL_TAGS_REPORT))
  end
  
end