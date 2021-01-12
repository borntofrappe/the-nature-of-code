LVector = require "LVector"
require "Spring"
require "Bob"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PIVOT_RADIUS = 4
BOB_RADIUS = 10
REST_LENGTH = 200
ARM_LINE_WIDTH = 1
MASS = 1
K = 20
GRAVITY = 10
DAMPING = 0.995

function love.load()
  love.window.setTitle("Oscillation - Spring")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  spring = Spring:new(WINDOW_WIDTH / 2, 0, REST_LENGTH)
  bob = Bob:new(WINDOW_WIDTH / 2, REST_LENGTH + 50)
end

function love.update(dt)
  local gravity = LVector:new(0, GRAVITY)
  bob:applyForce(gravity)
  spring:connect(bob)
  bob:update(dt)
end

function love.draw()
  spring:render()
  bob:render()
end
