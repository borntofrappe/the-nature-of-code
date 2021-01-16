LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 10
VELOCITY_UPPER_THRESHOLD = 500
ACCELERATION_MIN = 75
ACCELERATION_MAX = 200

function love.load()
  love.window.setTitle("Forces - Newtons's law")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  mover = Mover:new()

  fx = math.random(ACCELERATION_MIN, ACCELERATION_MAX)
  fy = math.random(ACCELERATION_MIN, ACCELERATION_MAX)
  if math.random() > 0.5 then
    fx = fx * -1
  end
end

function love.update(dt)
  local force = LVector:new(fx, fy)
  mover:applyForce(force)
  mover:update(dt)
end

function love.draw()
  mover:render()
end
