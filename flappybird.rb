require 'ruby2d'

HEIGHT = 540 
WIDTH = 360 

set width: WIDTH
set height: HEIGHT

class Bird
  def initialize
    @x = 30 
    @y = HEIGHT / 2
  end 

  def draw
    Square.new(x: @x, y: @y, size: 30, color: 'red')
  end 
end

bird = Bird.new
bird.draw

show 
