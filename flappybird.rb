require 'ruby2d'

HEIGHT = 640 
WIDTH = 420

set width: WIDTH
set height: HEIGHT
set fps_cap: 30

def draw_background
  Image.new('./assets/images/flappybirdbg.png', x: 0, y: 0, width: WIDTH, height: HEIGHT)
end 

def draw_score(score)
  Text.new(score, x: WIDTH / 2 - 30, y: 120, size: 60, color: 'white', z: 11)
end

def draw_game_over
  Text.new("GAME OVER", x: WIDTH/2 - 100, y: HEIGHT/2, size: 30, color: 'red', z: 11)
end

class Bird
  attr_reader :x, :y
  attr_writer :gravity, :velocity

  def initialize
    @x = 30 
    @y = HEIGHT / 2
    @width = 36
    @height = 33
    @gravity = 0.7
    @velocity = 0
  end 

  def draw
    Image.new('./assets/images/flappybird.png', x: @x, y: @y, width: @width, height: @height, z: 10)
  end
  
  def jump 
    @velocity = -8
  end 

  def move
    @velocity += @gravity
    @y = [@y + @velocity, 0].max
  end

  def felt?
    @y >= HEIGHT
  end
end

class Pipe
  attr_writer :scored, :moving_distance

  def initialize
    @width = 55 
    @height = 512/4 + rand(512/2)
    @x = WIDTH + @width
    @y = 0
    @open_gap = HEIGHT / 4
    @scored = false 
    @moving_distance = 5
  end

  def draw
    Image.new('./assets/images/toppipe.png',x: @x, y: @y, width: @width, height: @height, z: 10)

    Image.new('./assets/images/bottompipe.png', x: @x, y: @height + @open_gap, width: @width, height: HEIGHT - @height, z: 10)
  end

  def move
    @x -= @moving_distance
  end

  def hit?(x,y)
    (@x..@x + @width).include?(x) && ((0..@height).include?(y) || (@height+@open_gap..HEIGHT).include?(y))
  end 

  def out_of_scope?
    @x + @width <= 0 
  end

  def score? 
    passed? && !@scored
  end

  private
  def passed?
    @x <= 30
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

  if game_over
    draw_game_over
    next
  end

  pipes << Pipe.new if Window.frames % 40 == 0 
  
  if pipes.first.score? 
    pipes.first.scored = true 
    score += 1
  end 

  pipes.shift if pipes.first.out_of_scope?

  if pipes.first.hit?(bird.x,bird.y) || bird.felt?
    game_over = true
    pipes.each { |pipe| pipe.moving_distance = 0}
    bird.gravity = 0
    bird.velocity = 0
  end 
end

on :key_up do |event|
  bird.jump if event.key == 'space' && !game_over
end

show 
