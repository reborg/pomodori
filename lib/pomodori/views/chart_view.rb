require 'hotcocoa'
framework 'webkit'
require 'pomodori/controllers/charts_controller'

##
# UI components for the chart view.
#
class ChartView
  include HotCocoa
  attr_reader :hc_top_view, :hc_bottom_view, :hc_reload_button
  attr_reader :hc_close_button, :hc_web_view, :hc_chart_window

  def initialize(opts = {})
    @charts_controller = opts[:charts_controller]
  end
  
  def load_chart(url)
    hc_web_view.url = url
  end
  
  def render
    hc_chart_window
  end
 
  private

    def hc_chart_window
      @hc_chart_window ||= window(:frame => [100, 100, 500, 300], :title => "Reports") do |win|
        win << hc_bottom_view
        win << hc_top_view
        @charts_controller.on_load_view
      end
    end
    
    def hc_top_view
      @hc_top_view ||= layout_view(
        :mode => :horizontal,
        :layout => {:expand => [:width, :height]},
        :margin => 0, :spacing => 0) do |view|
        view << hc_web_view
      end
    end
    
    def hc_bottom_view
      @hc_bottom_view ||= layout_view(
        :mode => :horizontal,      
        :frame => [0, 0, 450, 50]) do |view|
        view << hc_reload_button
        view << hc_close_button      
      end
    end
    
    def hc_reload_button
      @hc_reload_button ||= button(
          :title => "Reload",
          :bezel => :textured_square,
          :frame => [525, 12, 66, 28],
          :on_action => reload_button_action)
    end
    
    def reload_button_action
      lambda {|sender| @charts_controller.on_reload_chart}
    end
    
    def hc_close_button
      @hc_close_button ||= button(
          :title => "Close",
          :bezel => :textured_square,
          :frame => [600, 12, 66, 28],
          :on_action => Proc.new {@hc_chart_window.close})
    end
    
    def hc_web_view
      @hc_web_view ||= web_view(
        :layout => {:expand =>  [:width, :height]})
    end

end
