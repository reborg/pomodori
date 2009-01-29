class Tomato
  attr_accessor :text
  
  def initialize(params = {})
    @text = params[:text]
  end
  
end