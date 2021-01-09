LVector = require "LVector"
require "Attractor"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_UPPER_THRESHOLD = 500
VELOCITY_MIN = 50
VELOCITY_MAX = 500
MOVERS = 20
RADIUS_MOVER = 2
MASS_MIN = 2
MASS_MAX = 5
RADIUS_ATTRACTOR = 20
MASS_ATTRACTOR = 20
DISTANCE_MIN = 5
DISTANCE_MAX = 20
GRAVITATIONAL_FORCE = 25000

function love.load()
  love.window.setTitle("Forces - Gravitational attraction - Complex")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  movers = {}
  for i = 1, MOVERS do
    local mass = math.random(MASS_MIN, MASS_MAX)
    table.insert(movers, Mover:new(mass))
  end
  attractor = Attractor:new()
end

function love.update(dt)
  for i, mover in ipairs(movers) do
    local attraction = attractor:attract(mover)
    mover:applyForce(attraction)
    mover:update(dt)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    for i, mover in ipairs(movers) do
      local attraction = attractor:pullIn(mover)
      mover:applyForce(attraction)
    end
  end
end

function love.draw()
  attractor:render()
  for i, mover in ipairs(movers) do
    mover:render()
  end
end
