require 'pomodori/models/chart'
require 'pomodori/views/chart_view'

class ChartsController
  attr_accessor :chart_view

  def initialize(params = {})
    @chart_view = params[:chart_view]
  end
  
  ##
  # Returns the local file URL containing the last
  # generation of the summary chart.
  #
  def on_load_view
    @chart_view.load_chart(Chart.new.process)
  end
  
  def on_open_report
    @chart_view = ChartView.new(:charts_controller => self)
    @chart_view.render
  end
  
  def on_reload_chart
    on_load_view
  end

end
