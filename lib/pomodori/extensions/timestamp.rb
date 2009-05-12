require 'time'

class String
  
  TIMESTAMP = /^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\s-\d{4}$/
  
  def flatten_date
    return self[0..9].gsub("-", "") if self.timestamp?
    ""
  end
  
  def timestamp?
    self =~ TIMESTAMP ? true : false
  end
  
  def strftime(format)
    time = Time.parse(self)
    time.strftime(format)
  end
  
end