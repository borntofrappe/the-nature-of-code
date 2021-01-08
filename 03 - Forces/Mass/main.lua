LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 2
VELOCITY_UPPER_THRESHOLD = 500
GRAVITY = 150
WIND = 200
MASS_MIN = 2
MASS_MAX = 10
MOVERS = 10

function love.load()
  love.window.setTitle("Forces - Mass")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  movers = {}
  for i = 1, MOVERS do
    local mass = math.random(MASS_MIN, MASS_MAX)
    table.insert(movers, Mover:new(mass))
  end
end

function love.update(dt)
  for i, mover in ipairs(movers) do
    local gravity = LVector:new(0, GRAVITY)
    mover:applyForce(LVector:multiply(gravity, mover.mass))

    if love.mouse.isDown(1) then
      local wind = LVector:new(WIND, 0)
      mover:applyForce(wind)
    end
    mover:update(dt)
  end
end

function love.draw()
  for i, mover in ipairs(movers) do
    mover:render()
  end
end
