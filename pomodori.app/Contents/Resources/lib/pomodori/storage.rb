require 'yaml'

class Storage
  attr_accessor :path
  TIMESTAMP_FORMAT = '%Y%m%d%H%M%S'
  
  def initialize(path = File.dirname(__FILE__) + "/")
    @path = path
  end
  
  def save(model)
    open(@path + timestamp, 'w') { |f| YAML.dump(model, f) }
  end
  
  def timestamp
    DateTime.now.strftime(TIMESTAMP_FORMAT)
  end
  
end