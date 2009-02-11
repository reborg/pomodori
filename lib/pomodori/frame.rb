class Frame
  
  attr_reader :x, :y, :width, :height
  
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end
  
  def ==(aframe)
    return false unless (aframe.x == @x && aframe.y == @y && aframe.width == @width && aframe.height == @height)
    true
  end
  
  def to_a
    [@x, @y, @width, @height]
  end
  
end