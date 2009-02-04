require File.dirname(__FILE__) + '/tomatoes'
require 'tomatoes/application'
require 'thirdparties/kirbybase'

data_dir = File.dirname(__FILE__) + '/../data'
FileUtils.mkdir(data_dir) unless File.exists? data_dir
db = KirbyBase.new(:local, nil, nil, data_dir)
db.create_table(:tomato, 
  :text, :String, 
  :timestamp, :Time) { |obj| obj.encrypt = false } unless db.table_exists?(:tomato)
Application.new.start