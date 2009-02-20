class Pomodoro
  attr_accessor :text, :timestamp
  
  def initialize(params = {})
    @text = fix_encoding(params[:text]) if params[:text]
    @timestamp = params[:timestamp]
  end
  
  def timestamp
    @timestamp ||= Time.now
  end
  
  ##
  # FIXME: When text is coming from a NSTextField it is in UTF-16
  # and the =~ operator is called on a UTF-16 string on MacRuby 0.3
  # it's giving error. This conversion to bytes and back to char
  # recreate the string as default encoding.
  def fix_encoding(fixme)
    plain = ""
    fixme.to_s.bytes.to_a.each {|c| plain << c.chr}
    plain
  end
  
  def text=(str)
    @text = fix_encoding(str)
  end
  
end