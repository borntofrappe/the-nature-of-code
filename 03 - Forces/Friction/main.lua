LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 10
VELOCITY_MIN = 50
VELOCITY_MAX = 200
VELOCITY_UPPER_THRESHOLD = 500
PUSH_STRENGTH = 50
FRICTION_COEFFICIENT = 20

function love.load()
  love.window.setTitle("Forces - Friction")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  mover = Mover:new()
end

function love.update(dt)
  local velocity = LVector:copy(mover.velocity)
  velocity:normalize()

  if velocity.x >= 0 then
    local friction = LVector:multiply(velocity, FRICTION_COEFFICIENT)
    friction:multiply(-1)
    mover:applyForce(friction)
  end

  if love.mouse.isDown(1) then
    local push = LVector:multiply(velocity, PUSH_STRENGTH)
    mover:applyForce(push)
  end

  mover:update(dt)
end

function love.draw()
  mover:render()
end
