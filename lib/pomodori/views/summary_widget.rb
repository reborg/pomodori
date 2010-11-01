##
# Creating a view guidelines.
# - For each HotCocoa element there should be an accessor method
# - All accessors are private but the view exposes business methods to change things without
#   exposing the internals of the implementation.
# - The accessor method can lazy initialize based on the need to save the element as
#   part of the instance for later access
# - Accessors are conventionally pre-fixed with hc to avoid name collision with the HotCocoa
#   helpers (i.e. window, button, label cannot be used as names for accessors)
# - The constructor usually accepts a hash of controllers instances (dependency injection)
#   which will be used to grab data
class SummaryWidget
  include HotCocoa

  def initialize(opts = {})
    update_yesterday_count(opts[:yesterday_count])
    update_today_count(opts[:today_count])
    update_average_count(opts[:average_count])
    hc_yesterday_count_button.on_action = opts[:on_click_yesterday]
    hc_today_count_button.on_action = opts[:on_click_today]
    hc_average_count_button.on_action = opts[:on_click_average]
  end

  def render
    rows
  end

  def update_yesterday_count(count)
    hc_yesterday_count_button.title = count.to_s
  end

  def update_today_count(count)
    hc_today_count_button.title = count.to_s
  end

  def update_average_count(count)
    hc_average_count_button.title = count.to_s
  end

  def show
    rows.setHidden(false)
  end

  def hide
    rows.setHidden(true)
  end

  private

    def rows
      @rows ||= layout_view(
        :mode => :vertical,
        :margin => 0,
        :spacing => 0, 
        :layout => {:start => false},
        :frame => [264, 65, 100, 60]) do |v|
        v << hc_row_layout_view([0,0,0,20], hc_average_count_button, hc_label("Average:"))
        v << hc_row_layout_view([0,0,0,20], hc_today_count_button, hc_label("Today:"))
        v << hc_row_layout_view([0,0,0,20], hc_yesterday_count_button, hc_label("Yesterday:"))
      end
    end

    def hc_yesterday_count_button
      @hc_yesterday_count_button ||= hc_count_button
    end

    def hc_today_count_button
      @hc_today_count_button ||= hc_count_button
    end

    def hc_average_count_button
      @hc_average_count_button ||= hc_count_button
    end

    def hc_count_button
      button(
        :frame => [0,0,25,20],
        :bezel => :shadowless_square,
        :font => font(:name => "Andale Mono", :size => 12),
        :layout => {:start => false})
    end
    
    def hc_row_layout_view(aframe, abutton, alabel)
      layout_view(
        :mode => :horizontal, 
        :frame => aframe,
        :margin => 0,
        :spacing => 0,
        :layout => {
          :expand => [:width], 
          :padding => 0}) do |v|
        v << abutton
        v << alabel
      end
    end

    def hc_label(text = "")
      label(
        :text => text,
        :layout => {:expand => [:width]},
        :font => font(:name => "Andale Mono", :size => 12))
    end

end
