require 'thirdparties/kirbybase'
require 'pomodori/models/pomodoro'

class KirbyStorage
  attr_accessor :path, :db
  
  DB_PATH = File.expand_path("~/Library/Application Support/Pomodori")
  SECS_IN_DAY = 60 * 60 * 24
  
  def initialize(path = DB_PATH)
    @path = path
    KirbyStorage.create_db(path)
    @db = KirbyBase.new(:local, nil, nil, path)
  end
  
  def save(object)
    table_for(object).insert(:text => object.text, :timestamp => object.timestamp)
  end
  
  def find_all(clazz)
    start = Time.now
    all = table_for(clazz).select
    NSLog(" [PERF]: find_all took '#{Time.now - start}'")
    all
  end
  
  def find_all_day_before(clazz, today)
    all = find_all_by_date(clazz, today - SECS_IN_DAY)
  end

  def find_all_by_date(clazz, date)
    all = table_for(clazz).select { |r| r.timestamp.year == date.year and r.timestamp.month == date.month and r.timestamp.day == date.day }
  end
  
  ##
  # Database migration lives here. Called by main.rb
  # at startup.
  #
  def self.init_db
    create_db(DB_PATH)
    db = KirbyBase.new(:local, nil, nil, DB_PATH)
    db.create_table(:pomodoro,
      :text, :String,
      :timestamp, :Time) { |obj| obj.encrypt = false } unless db.table_exists?(:pomodoro)
  end
  
  private
  
    def table_for(object)
      sym = object.class.to_s.downcase.to_sym
      sym = object.to_s.downcase.to_sym if object.class == Class
      @db.get_table(sym)
    end
    
    ##
    # Creates the directory for the database if the path
    # doesn't exist
    #
    def self.create_db(path)
      FileUtils.mkdir(path) unless File.exists?(path)
    end
  
end