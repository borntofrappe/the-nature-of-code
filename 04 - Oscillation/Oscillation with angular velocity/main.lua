LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 14
UPDATE_SPEED = 50
ANGULAR_VELOCITY_MIN = 1
ANGULAR_VELOCITY_MAX = 4
MOVERS = 10
AMPLITUDE_MIN = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 5)
AMPLITUDE_MAX = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 2.5)

function love.load()
  love.window.setTitle("Oscillation - Oscillation with angular velocity")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  movers = {}
  for i = 1, MOVERS do
    local mover = Mover:new()
    table.insert(movers, mover)
  end
end

function love.update(dt)
  for i, mover in ipairs(movers) do
    mover:update(dt)
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  for i, mover in ipairs(movers) do
    love.graphics.setColor(0.11, 0.11, 0.11, 0.5)
    love.graphics.setLineWidth(1)
    love.graphics.line(0, 0, mover.x, mover.y)
    mover:render()
  end
end
