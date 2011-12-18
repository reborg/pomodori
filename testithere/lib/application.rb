require 'rubygems' # disable this for a deployed application
require 'hotcocoa'

class Testithere
  include HotCocoa

  def start
    application name: 'Testithere' do |app|
      app.delegate = self
      window frame: [100, 100, 500, 500], title: 'Testithere' do |win|
        win << label(text: 'Hello from HotCocoa', layout: {start: false})
        win.will_close { exit }
      end
    end
  end

  # file/open
  def on_open(menu)
  end

  # file/new
  def on_new(menu)
  end

  # help menu item
  def on_help(menu)
  end

  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end

  # window/zoom
  def on_zoom(menu)
  end

  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end
end

Testithere.new.start
