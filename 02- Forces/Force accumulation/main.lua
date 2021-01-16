LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 10
VELOCITY_UPPER_THRESHOLD = 500
GRAVITY = 150
WIND = 200

function love.load()
  love.window.setTitle("Forces - Force accumulation")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  mover = Mover:new()
end

function love.update(dt)
  local gravity = LVector:new(0, GRAVITY)
  mover:applyForce(gravity)

  if love.mouse.isDown(1) then
    local wind = LVector:new(WIND, 0)
    mover:applyForce(wind)
  end

  mover:update(dt)
end

function love.draw()
  mover:render()
end
