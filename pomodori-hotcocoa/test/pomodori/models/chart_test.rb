require File.dirname(__FILE__) + '/../../test_helper'
require 'pomodori/models/chart'
require 'pomodori/models/pomodoro_count_by_day'

class ChartTest < Test::Unit::TestCase
  
  def setup
    @chart = Chart.new(:template_path => File.dirname(__FILE__))
    PomodoroCountByDay.stubs(:find_all).returns(pomodoro_count_by_day_sample)
  end
  
  def test_should_load_deafult
    assert_match(/Test Summary Template/, open(@chart.process).read)
  end
  
  def test_should_load_deifferent_template_file
    assert_match(/Another Test Template/, open(@chart.process(
      File.dirname(__FILE__),
      "another_template.html")).read)
  end
  
  def test_extract_tag_content
    assert_equal("content", @chart.extract_tag("<%= content  %>"))
  end
  
  def test_call_method_from_tag
    @chart.expects(:pomodoro_summary).returns("A nice summary")
    assert_match(/A nice summary/, @chart.process_line("<%= pomodoro_summary %>"))
  end
  
  def test_should_return_unaltered_line_if_no_tag
    assert_match(/no change/, @chart.process_line("no change"))
  end
  
  def test_creates_temp_file
    path = @chart.create_temp_file("content")
    assert_match("pomodori_chart", path)
    assert_equal("content", File.open(path).read)
  end

  def test_generates_summary_html
    html = @chart.pomodoro_summary
    assert_match(/<span class="date">2009-03-01<\/span>/, html)
    assert_match(/<span class="date">2009-03-02<\/span>/, html)
  end
  
  def test_template_was_processed
    @chart.expects(:pomodoro_summary).returns('was_processed')
    processed_path = @chart.process(File.dirname(__FILE__),"another_template.html")
    assert_match(/was_processed/, open(processed_path).read)
  end
  
end
