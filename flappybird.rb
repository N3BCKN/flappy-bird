require 'ruby2d'

HEIGHT = 540 
WIDTH = 360
GRAVITY = 0.7

set width: WIDTH
set height: HEIGHT
set fps_cap: 30

def draw_background
  Image.new('./assets/images/flappybirdbg.png', x: 0, y: 0, width: WIDTH, height: HEIGHT)
end 

class Bird
  attr_reader :x, :y

  def initialize
    @x = 30 
    @y = HEIGHT / 2
    @width = 36
    @height = 33
    @velocity = 2
  end 

  def draw
    Image.new(
      './assets/images/flappybird.png',
      x: @x, y: @y,
      width: @width, height: @height,
      z: 10
    )
  end
  
  def jump 
    @velocity = -6
  end 

  def move
    @velocity += GRAVITY
    @y = [@y + @velocity, 0].max
  end 
end

class Pipe
  def initialize
    @width = 45 
    @height = HEIGHT / 2 - rand() * HEIGHT / 5 
    @x = WIDTH + @width
    @y = 0
    @open_gap = @height / 3
    @y_bottom = HEIGHT - @height + @open_gap
  end

  def draw
    Image.new('./assets/images/toppipe.png',
    x: @x,
    y: @y,
    width: @width,
    height: @height,
    z: 10)

    Image.new('./assets/images/bottompipe.png',
    x: @x,
    y: @y_bottom,
    width: @width,
    height: @height_bottom,
    z: 10)
  end

  def move
    @x -= 5
  end

  def hit?(x,y)
    (@x..@x + @width).include?(x)
  end 

  def out_of_scope?
    @x + @width <= 0 
  end
end


bird = Bird.new
pipes = []
pipes << Pipe.new 

update do
  clear 

  draw_background
  bird.draw
  bird.move

  pipes.each do |pipe|
    pipe.draw
    pipe.move
  end 

  if Window.frames % 30 == 0 
    pipes << Pipe.new 
  end  

  pipes.shift if pipes.first.out_of_scope?
end

on :key_up do |event|
  bird.jump if event.key == 'space'
end


show 
