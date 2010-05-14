require 'thirdparties/kirbybase'
require 'pomodori/models/pomodoro'
framework 'foundation'

class KirbyStorage
  attr_accessor :path, :db
  @@pomodoros = nil
  
  DB_PATH = File.expand_path("~/Library/Application Support/Pomodori")
  SECS_IN_DAY = 60 * 60 * 24
  
  def initialize(path = DB_PATH)
    @path = path
    @db = KirbyBase.new(:local, nil, nil, path)
  end
  
  def save(object)
    table_for(object).insert(:text => object.text, :timestamp => object.timestamp)
  end
  
  def find_all(clazz)
    #start = Time.now
    @@pomodoros ||= table_for(clazz).select
    #NSLog(" [PERF]: find_all took '#{Time.now - start}'")
    @@pomodoros
  end

  def invalidate_caches
    @@pomodoros = nil
  end
  
  def find_all_day_before(clazz, today)
    all = find_all_by_date(clazz, today - SECS_IN_DAY)
  end

  def find_all_by_date(clazz, date)
    all = table_for(clazz).select { |r| r.timestamp.flatten_date == date.to_s.flatten_date }
  end

  def last(clazz)
    table = table_for(clazz)
    last_id = @db.engine.get_header_vars(table)[1]
    fields = table[last_id]
    Pomodoro.new(:text => fields[:text], :timestamp => fields[:timestamp]) if fields
  end
    
  private
  
    def table_for(object)
      sym = object.class.to_s.downcase.to_sym
      sym = object.to_s.downcase.to_sym if object.class == Class
      @db.get_table(sym)
    end
      
end
