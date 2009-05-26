require 'hotcocoa'

class SummaryWidget
  include HotCocoa
  attr_reader :hc_row_layout_view, :hc_label, :hc_button
  attr_reader :yesterday_count, :today_count, :average_count

  def initialize(opts = {})
    @yesterday_count = opts[:yesterday_count]
    @today_count = opts[:today_count]
    @average_count = opts[:average_count]
  end
  
  def render
    rows
  end

  def rows
    @rows ||= layout_view(:mode => :vertical, :frame => [115, 60, 250, 62]) do |v|
      v << hc_row_layout_view("Yesterday", @yesterday_count, [0, 0, 250, 20]) 
      v << hc_row_layout_view("Today", @today_count, [0, 0, 250, 20]) 
      v << hc_row_layout_view("Average", @average_count, [0, 0, 250, 20]) 
    end
  end
  
  def hc_row_layout_view(title, text, frame)
    layout_view(:mode => :horizontal, :frame => frame) do |v|
      v << hc_button(title)
      v << hc_label(text)
    end
  end

  def hc_button(title)
    button(:title => title, :bezel => :small_square, :layout => {:start => false})
  end

  def hc_label(text)
    label(text, :layout => {:align => :center})
  end
  
end
