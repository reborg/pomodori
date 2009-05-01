Dir[File.dirname(__FILE__) + "/../vendor/**/lib"].each do |dir|
  $LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)
end

require "mocha"
require "matchy"
require "test/unit"
require "microspec"
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

def pomodoros(how_many = 10)
  pomos = []
  how_many.times do |i|
    pomos << Pomodoro.new(
      :text => "Pomo#{i}",
      :timestamp => DateTime.new(2009, 03, i % 3 + 1))
  end
  pomos
end

def pomodoro_count_by_day_sample
  pomos = []
  3.times do |i|
    pomos << PomodoroCountByDay.new(DateTime.new(2009, 03, i % 3 + 1), pomodoros(i))
  end
  pomos
end
