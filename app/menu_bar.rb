class MenuBar
  def self.create_menu
    NSLog("create_menu enter")
    menu_zone = NSMenu.menuZone
    menu = NSMenu.allocWithZone(menu_zone).init
    menu_item = menu.addItemWithTitle("Average: 12", action:nil, keyEquivalent:"")
    menu_item = menu.addItemWithTitle("Quit Pomodori", action:nil, keyEquivalent:"q")
    menu_item.setToolTip("Click to quit Pomodori")
    menu_item.setTarget(self)
    NSLog("create_menu exit")
    menu
  end
  def self.on_quit(sender)
    NSLog("on_quit")
    NSApp.terminate(sender) 
  end
end
