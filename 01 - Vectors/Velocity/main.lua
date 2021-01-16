LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_MIN = 50
VELOCITY_MAX = 150
RADIUS = 10
MOVERS = 10

function love.load()
  love.window.setTitle("Vectors - Velocity")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  movers = {}
  for i = 1, MOVERS do
    table.insert(movers, Mover:new())
  end
end

function love.update(dt)
  for i, mover in ipairs(movers) do
    mover:update(dt)
  end
end

function love.draw()
  for i, mover in ipairs(movers) do
    mover:render()
  end
end
