class ApplicationDelegate
  def applicationDidFinishLaunching(sender)
    # FIXME: not working right now, disappearing after 1 second
    #initialize_menu_bar
    NSLog("applicationDidFinishLaunching")
  end
  def initialize_menu_bar
    menu_bar_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSSquareStatusItemLength)
    menu_bar_item.setMenu(MenuBar.create_menu)
    menu_bar_item.setHighlightMode(true)
    menu_bar_item.setToolTip("Pomodori")
    menu_bar_item.setImage(NSImage.imageNamed("Pomodori18"))
    menu_bar_item.setEnabled(true)
  end
end
