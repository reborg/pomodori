require 'hotcocoa'

class HistoryView
  include HotCocoa
  
  DESCR_COLUMN_SIZE = 50
  
  def initialize(opts = {})
  end

  def update_title(title)
    @hc_history_window.title = title.to_s
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
    return [{:text => "\nThe next pomodoro will go better!", :timestamp => "None"}] unless pomodoros.size > 0
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

  def render
    hc_history_window
  end
  
  private

    def hc_history_window
      @hc_history_window ||= window(
        :frame => [100, 100, 500, 400], 
        # :style => :borderless,
        :title => "History") do |win|
        win << hc_bottom_layout_view
        win << hc_scroll_view
      end
    end

    def hc_bottom_layout_view
      @hc_bottom_layout_view ||= layout_view(
        :mode => :horizontal, 
        :frame => [0,0,0,30],
        :margin => 0,
        :spacing => 4,
        :layout => {:expand => [:width], :padding => 0}) do |v|
          v << hc_close_button
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
        :frame => [0, 0, 66, 28],
        :on_action => close_window_action)
    end

    def close_window_action
      lambda {|sender| hc_history_window.close}
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

