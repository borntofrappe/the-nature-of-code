LVector = require "LVector"
require "Attractor"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS_ATTRACTOR = 10
RADIUS_MOVER = 5
VELOCITY_UPPER_THRESHOLD = 500
VELOCITY_MIN = 20
VELOCITY_MAX = 100
DISTANCE_MIN = 5
DISTANCE_MAX = 20
GRAVITATIONAL_FORCE = 25000

function love.load()
  love.window.setTitle("Forces - Gravitational attraction - Simple")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  mover = Mover:new()
  attractor = Attractor:new()
end

function love.update(dt)
  local attraction = attractor:attract(mover)
  mover:applyForce(attraction)
  mover:update(dt)
end

function love.draw()
  attractor:render()
  mover:render()
end
