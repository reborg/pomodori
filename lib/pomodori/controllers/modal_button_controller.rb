class ModalButtonController
  attr_reader :main_view
  
  def initialize(opts)
    @main_view = opts[:main_view]
    on_click("Void", :on_click_void)
  end
  
  def on_click_void(sender)
    on_click("Restart", :on_click_restart, :break_mode)
  end
  
  def on_click_restart(sender)
    on_click("Void", :on_click_void, :running_mode)
  end
  
  def on_click_submit(sender)
    on_click_void(sender)
  end
  
  private
  
    ##
    # The mode default to nil? is because I want to send something
    # that doesn't do anything.
    #
    def on_click(label, action, mode = :nil?)
      @main_view.update_modal_button_label(label)
      @main_view.update_modal_button_action(method(action))
      @main_view.send(mode)
    end
  
end