require 'thirdparties/kirbybase'

class KirbyStorage
  attr_accessor :path, :db
  
  DB_PATH = "#{ENV['HOME']}/Library/Application Support/Pomodori"
  
  def initialize(path = DB_PATH)
    @path = path
    KirbyStorage.create_db(path)
    @db = KirbyBase.new(:local, nil, nil, path)
  end
  
  def save(object)
    table_for(object).insert(:text => object.text, :timestamp => object.timestamp)
  end
  
  def find_all(clazz)
    table_for(clazz).select
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
      sym = object.class.to_s.to_sym
      sym = object.to_s.to_sym if object.class == Class
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