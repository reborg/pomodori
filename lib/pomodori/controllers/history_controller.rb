require 'pomodori/views/history_view'
require 'pomodori/controllers/history_controller'

class HistoryController

  def initialize(params = {})
    @history_view = params[:history_view]
    @pomodori_controller = params[:pomodori_controller] ||= PomodoriController.new
  end

  def on_open_history(what)
    @history_view = HistoryView.new(:history_controller => self)
    @history_view.render
    @history_view.update_title(what)
    @history_view.refresh(@pomodori_controller.send(:"#{what}_pomodoros"))
  end

end
