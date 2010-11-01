require 'pomodori/kirby_storage'
require 'thirdparties/kirbybase'

class Migration
  
  TIMESTAMP_REGEXP = /\|timestamp:Time/
  
  def self.migrate(file)
    content = File.read(file)
    File.open(file, 'w+') do |f| 
      f << content.gsub(TIMESTAMP_REGEXP, "|timestamp:String")
    end
  end
  
  ##
  # Database migration lives here. Called by main.rb
  # at startup.
  #
  def self.init_db(path = KirbyStorage::DB_PATH)
    FileUtils.mkdir(path) unless File.exists?(path)
    db = KirbyBase.new(:local, nil, nil, path)
    if db.table_exists?(:pomodoro)
      migrate(path + "/pomodoro.tbl")
    else
      db.create_table(:pomodoro,
        :text, :String,
        :timestamp, :String) { |obj| obj.encrypt = false }
    end
    db
  end
  
end