require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/controllers/history_controller'
require 'hotcocoa'

class HistoryControllerTest < Test::Unit::TestCase
  include HotCocoa

  def setup
    @pomodoros = pomodoros
    @history_view = mock(:render => true)
    @pomodori_controller = mock
    @history_controller = HistoryController.new(
      :history_view => @history_view,
      :pomodori_controller => @pomodori_controller)
  end
  
# it "should dispatch on correct method on load view" do
#   @pomodori_controller.expects(:yesterday_pomodoros).returns(@pomodoros)
#   @history_view.expects(:refresh).with(@pomodoros)
#   @history_controller.on_open_history(:yesterday)
# end
    
end
