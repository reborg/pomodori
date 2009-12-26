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
      @hc_chart_window ||= window(:frame => [100, 100, 500, 400], :title => "Reports") do |win|
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
        :margin => 0,
        :spacing => 4,
        :layout => {:expand => [:width], :padding => 0},
        :frame => [0, 0, 0, 30]) do |view|
        view << hc_reload_button
        view << hc_close_button      
      end
    end
    
    def hc_reload_button
      @hc_reload_button ||= button(
          :title => "Reload",
          :bezel => :textured_square,
          :frame => [0, 0, 66, 28],
          :on_action => reload_button_action)
    end
    
    def reload_button_action
      lambda {|sender| @charts_controller.on_reload_chart}
    end
    
    def hc_close_button
      @hc_close_button ||= button(
          :title => "Close",
          :bezel => :textured_square,
          :frame => [0, 0, 66, 28],
          :on_action => close_window_action)
    end

    def close_window_action
      lambda { |sender| hc_chart_window.close } 
    end
    
    def hc_web_view
      @hc_web_view ||= web_view(
        :layout => {:expand =>  [:width, :height]})
    end

end
