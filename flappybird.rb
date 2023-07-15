require 'ruby2d'

HEIGHT = 640 
WIDTH = 420
GRAVITY = 0.7

set width: WIDTH
set height: HEIGHT
set fps_cap: 30

def draw_background
  Image.new('./assets/images/flappybirdbg.png', x: 0, y: 0, width: WIDTH, height: HEIGHT)
end 

def draw_score(score)
  Text.new(score, x: 30, y: 30, size: 40, color: 'white', z: 11)
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
    @velocity = -8
  end 

  def move
    @velocity += GRAVITY
    @y = [@y + @velocity, 0].max
  end

  def felt?
    @y >= HEIGHT
  end
end

class Pipe
  def initialize
    @width = 55 
    @height = 512/4 + rand(512/2)
    @x = WIDTH + @width
    @y = 0
    @open_gap = HEIGHT / 4
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
    y: @height + @open_gap,
    width: @width,
    height: HEIGHT - @height,
    z: 10)
  end

  def move
    @x -= 5
  end

  def hit?(x,y)
    (@x..@x + @width).include?(x) && ((0..@height).include?(y) || (@height+@open_gap..HEIGHT).include?(y))
  end 

  def out_of_scope?
    @x + @width <= 0 
  end

  def passed? 
    @x > 30
  end
end


bird = Bird.new
pipes = []
pipes << Pipe.new
score = 0
game_over = false

update do
  clear 

  draw_background
  draw_score(score)
  bird.draw
  bird.move

  pipes.each do |pipe|
    pipe.draw
    pipe.move
  end 

  if Window.frames % 40 == 0 
    pipes << Pipe.new 
  end  

  # p pipes.first.hit?(bird.x,bird.y)
  # p bird.felt?
  p pipes.first.passed?
  pipes.shift if pipes.first.out_of_scope?
end

on :key_up do |event|
  bird.jump if event.key == 'space'
end


show 
