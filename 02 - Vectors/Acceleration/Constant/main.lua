LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_MIN = 50
VELOCITY_MAX = 150
VELOCITY_UPPER_THRESHOLD = 500
VELOCITY_LOWER_THRESHOLD = 20
RADIUS = 10
ACCELERATION = 100

function love.load()
  love.window.setTitle("Vectors - Acceleration - Constant")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  mover = Mover:new()
end

function love.update(dt)
  mover:update(dt)
end

function love.draw()
  mover:render()
end
