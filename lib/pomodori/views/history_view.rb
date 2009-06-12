require 'hotcocoa'

class HistoryView
  include HotCocoa
  DESCR_COLUMN_SIZE = 50
  
  attr_reader :table, :history_window
  
  def initialize(opts = {})
    
  end

  def update_title(title)
    @history_window.title = title.to_s
  end
  
  def render
    history_window
  end
  
  def history_window
    @history_window ||= window(
      :frame => [100, 100, 500, 200], 
      # :style => :borderless,
      :title => "History") do |win|
      win << hc_scroll_view
      win.background_color = color(:name => :white)
    end
  end
  
  def hc_scroll_view
    @hc_scroll_view ||= scroll_view(
      :layout => {:expand => [:width, :height]},
      :vertical_scroller => true, :horizontal_scroller => false) do |scroll|
      scroll << hc_table_view
    end
  end

  def hc_table_view
    return @hc_table_view unless @hc_table_view.nil?
    @hc_table_view = table_view(
      :columns => [
        hc_timestamp_column, 
        column(:id => :text, :title => "What")
      ]
    )
    # A single line is 17 pixels by default, these are 3 lines.
    @hc_table_view.setRowHeight(51)
    @hc_table_view.setUsesAlternatingRowBackgroundColors(true)
    @hc_table_view.setHeaderView(nil)
    @hc_table_view
  end

  def hc_timestamp_column 
    c = column(:id => :timestamp, :title => "When") 
    c.setMaxWidth(80)
    c.setMinWidth(80)
    c.setDataCell(TimeStampCell.new)
    c
  end
  
  def hc_close_button
    @close_button ||= button(
      :title => "Close",
      :bezel => :textured_square,
      :frame => [600, 12, 66, 28],
      :on_action => Proc.new {@chart_window.close})
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
    hc_table_view.data = hashify(pomodoros)
    hc_table_view.reloadData
  end
  
end

##
# Thanks!
# http://everburning.com/news/heating-up-with-hotcocoa-part-iii/
#
class TimeStampCell < NSCell
  def drawInteriorWithFrame(frame, inView:view)
    NSColor.colorWithCalibratedRed("fa".hex/ 255.0, green:"8c".hex/255.0, blue:"40".hex/255.0, alpha:100).set
    NSRectFill(frame)

    rank_frame = NSMakeRect(frame.origin.x + (frame.size.width / 2) - 26,
                            frame.origin.y + (frame.size.height / 2) - 6, frame.size.width, 17)

    objectValue.to_s.drawInRect(rank_frame, withAttributes:nil)
  end
end

