LVector = require "LVector"
require "Attractor"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_UPPER_THRESHOLD = 400
MOVERS = 10
RADIUS_MOVER = 2
MASS_MIN = 3
MASS_MAX = 5
MASS_ATTRACTOR = 30
DISTANCE_MIN = 5
DISTANCE_MAX = 20
GRAVITATIONAL_FORCE = 25000
REPULSION_FORCE = 10000

function love.load()
  love.window.setTitle("Forces - Gravitational attraction - Mouse")
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

    for j, m in ipairs(movers) do
      if i ~= j then
        local repulsion = m:repulse(mover)
        mover:applyForce(repulsion)
      end
    end

    mover:update(dt)
  end

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local position = LVector:new(x, y)
    attractor.position = position
  end
end

function love.draw()
  -- attractor:render()
  for i, mover in ipairs(movers) do
    mover:render()
  end
end
