require 'hotcocoa'

class HistoryView
  include HotCocoa
  DESCR_COLUMN_SIZE = 50
  
  attr_reader :table, :history_window
  
  def initialize(opts = {})
    
  end
  
  def render
    history_window
  end
  
  def history_window
    @history_window ||= window(
      :frame => [100, 100, 500, 200], 
      # :style => :borderless,
      :title => "Tableview") do |win|
      win << table
      win.background_color = color(:name => :white)
    end
  end
  
  ##
  # Accessor for the table view with default settings
  # 
  def table
    @table ||= scroll_view(
      :layout => {:expand => [:width, :height]},
      :column_resize => :last_column_only,
      :vertical_scroller => true, :horizontal_scroller => false) do |scroll|
      mytable = table_view(
        :columns => [
          column(:id => :timestamp, :title => "When"), 
          column(:id => :text, :title => "What")
        ]
      )
      # A single line is 17 pixels by default, these are 3 lines.
      mytable.setRowHeight(51)
      mytable.setUsesAlternatingRowBackgroundColors(true)
      mytable.setHeaderView(nil)
      scroll << mytable
    end
  end
  
  ##
  # Formats the time for display on the table cell.
  #
  def format_time(time)
    time.strftime('%I:%M%p').downcase
  end
  
  ##
  # It splits a sentece into multiple newline separated lines
  # so that it fits into a given character lenght
  # The regular expression is explained here:
  # http://blog.macromates.com/2006/wrapping-text-with-regular-expressions
  #
  def smart_split(text, chars)
    text.gsub(/(.{1,#{chars}})( +|$\n?)|(.{1,#{chars}})/, "\\1\\3\n").chomp
  end
  
  ##
  # Convert an array of pomodoros into an array
  # of hashified pomodoros
  # 
  def hashify(pomodoros)
    pomodoros.inject([]) do |array, pomodoro| 
      array << {
        :text => smart_split(pomodoro.text, DESCR_COLUMN_SIZE), 
        :timestamp => format_time(pomodoro.timestamp)
      }
    end
  end
  
  def refresh(pomodoros)
    table.data = hashify(pomodoros)
  end
  
end