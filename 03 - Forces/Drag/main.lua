LVector = require "LVector"
require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 2
VELOCITY_MIN = 50
VELOCITY_MAX = 200
VELOCITY_UPPER_THRESHOLD = 500
GRAVITY = 150
MASS_MIN = 2
MASS_MAX = 10
MOVERS = 10
DRAG_COEFFICIENT_DENSITY_1 = 0.01
DRAG_COEFFICIENT_DENSITY_2 = 0.1

function love.load()
  love.window.setTitle("Forces - Drag")
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
  for i = #movers, 1, -1 do
    local mover = movers[i]
    local gravity = LVector:new(0, GRAVITY)
    mover:applyForce(LVector:multiply(gravity, mover.mass))

    -- if mover.velocity.y >= 0 then
    local drag = LVector:copy(mover.velocity)
    drag:normalize()
    drag:multiply(-1)
    local coefficient =
      mover.position.y + mover.r < WINDOW_HEIGHT / 2 and DRAG_COEFFICIENT_DENSITY_1 or DRAG_COEFFICIENT_DENSITY_2
    local magnitude = mover.velocity:getMagnitude()
    drag:multiply(coefficient * magnitude ^ 2)
    mover:applyForce(drag)
    -- end

    mover:update(dt)

    if mover.position.y > WINDOW_HEIGHT + mover.r then
      table.remove(movers, i)
      local mass = math.random(MASS_MIN, MASS_MAX)
      table.insert(movers, Mover:new(mass))
    end
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.3)
  love.graphics.rectangle("fill", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, WINDOW_HEIGHT / 2)

  for i, mover in ipairs(movers) do
    mover:render()
  end
end
