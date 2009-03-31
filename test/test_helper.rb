lib_path = File.expand_path(File.dirname(__FILE__) + "/../mocha-0.9.5/lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require "mocha"
require "test/unit"
require File.dirname(__FILE__) + '/../lib/pomodori'

def wipe_dir(dir, regex = /.tbl/)
  Dir.entries(dir).each do |name|
    path = File.join(dir, name)
    if name =~ regex
      ftype = File.directory?(path) ? Dir : File
      begin
        ftype.delete(path)
      rescue SystemCallError => e
        $stderr.puts e.message
      end
    end
  end
end

def pomodoros
  pomos = []
  10.times do |i|
    pomos << Pomodoro.new(
      :text => "Pomo#{i}",
      :timestamp => DateTime.new(2009, 03, i % 3 + 1))
  end
  pomos
end

def pomodoro_count_by_day_sample
  pomos = []
  3.times do |i|
    pomos << PomodoroCountByDay.new(DateTime.new(2009, 03, i % 3 + 1), pomodoros)
  end
  pomos
end
