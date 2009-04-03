require 'fileutils'
require 'tempfile'
require 'pomodori/models/pomodoro_count_by_day'

##
# Chart will initialize on the default path
# with the summary template as default chart. The actual
# load is done by load_template with optional overriding
# path and chart template. The template contains methods
# call to this class that will expand into HTML for the
# rendered template. So for example <%= pomodoro_summary %>
# will call the pomodoro_summary method and use the output
# in place of the call in the template HTML file.
#
class Chart

  attr_reader :template_name, :template_path

  TAG_REGEXP = /\<\%\=(.+?)\%\>/
  DEFAULT_PATH = File.join(NSBundle.mainBundle.resourcePath.fileSystemRepresentation, "charts")

  def initialize(opts = {})
    @template_name = opts[:template_name] ||= "summary_template.html"
    @template_path = opts[:template_path] ||= DEFAULT_PATH
  end
  
  def process(path = template_path, name = template_name)
    processed = ""
    open(File.join(path, name)).each do |line|
      processed << process_line(line)
    end
    create_temp_file(processed)
  end
  
  def extract_tag(line)
    line.match(TAG_REGEXP)[1].strip if line.match(TAG_REGEXP)
  end
  
  def process_line(line)
    extract_tag(line) ? send(extract_tag(line)).to_sym : line
  end
  
  ##
  # Produces HTML relevant to the pomodoro summary
  # chart template. The % is multiplied by 5 because
  # I assume there will never be more than 20 pomos a day.
  #
  def pomodoro_summary
    html = ""
    pomos = PomodoroCountByDay.find_all
    pomos.each do |pomo|
      html << "<li>"
        html << "<span class=\"date\">#{pomo.date.strftime('%Y-%m-%d')}</span>"
        html << "<span class=\"count\">#{pomo.count}</span>"
        html << "<span class=\"index\" style=\"width: #{pomo.count * 5}%\"></span>"
      html << "</li>"
    end
    html
  end
  
  def create_temp_file(content)
    out = Tempfile.new("pomodori_chart")
    out << content
    out.close
    out.path
  end
  
end