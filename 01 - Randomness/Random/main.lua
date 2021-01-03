require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 5

function love.load()
  love.window.setTitle("Randomness - Random")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  mover = Mover:new()
end

function love.update(dt)
  mover:randomWalk()
end

function love.draw()
  mover:render()
end
