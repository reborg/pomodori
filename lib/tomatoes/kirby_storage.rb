require 'thirdparties/kirbybase'

class KirbyStorage
  attr_accessor :path, :db
  
  def initialize(path = File.dirname(__FILE__) + "/../../data")
    @path = path
    @db = KirbyBase.new(:local, nil, nil, path)
  end
  
  def save(object)
    table_for(object).insert(:text => object.text, :timestamp => object.timestamp)
  end
  
  def find_all(clazz)
    table_for(clazz).select
  end
  
  private
  
    def table_for(object)
      sym = object.class.to_s.to_sym
      sym = object.to_s.to_sym if object.class == Class
      @db.get_table(sym)
    end
  
end