require 'hotcocoa'
framework 'webkit'
require 'pomodori/controllers/charts_controller'

##
# UI components for the chart view.
#
class ChartView
  include HotCocoa
  attr_reader :top_view, :bottom_view, :reload_button, :close_button, :browser, :chart_window

  def initialize(opts = {})
    @charts_controller = opts[:charts_controller]
  end
  
  def render
    chart_window
  end
  
  def chart_window
    @chart_window ||= window(:frame => [100, 100, 500, 300], :title => "Reports") do |win|
      win << bottom_view
      win << top_view
      @charts_controller.on_load_view
    end
  end
  
  def top_view
    @top_view ||= layout_view(
      :mode => :horizontal,
      :layout => {:expand => [:width, :height]},
      :margin => 4, :spacing => 0) do |view|
      view << browser
    end
  end
  
  def bottom_view
    @bottom_view ||= layout_view(
      :mode => :horizontal,      
      :frame => [0, 0, 450, 50]) do |view|
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
      :layout => {:expand =>  [:width, :height]})
  end
  
  ##
  # SERVICES
  ##
  
  def load_chart(url)
    browser.url = url
  end
end