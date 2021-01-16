LVector = require "LVector"
require "Pendulum"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PIVOT_RADIUS = 3
BOB_RADIUS = 10
ARM_LENGTH = 50
ARM_LINE_WIDTH = 1
UPDATE_SPEED = 18
GRAVITY = 100
DAMPING = 0.995
PENDULUMS_ROWS = 6
PENDULUMS_COLUMNS = 10

function love.load()
  love.window.setTitle("Oscillation - Pendulum")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  pendulums = {}
  for i = 1, PENDULUMS_ROWS do
    for j = 1, PENDULUMS_COLUMNS do
      local angle = math.rad(90 - 30 * ((j - 1) + (i - 1) * PENDULUMS_COLUMNS) / (PENDULUMS_ROWS * PENDULUMS_COLUMNS))
      local x = j * WINDOW_WIDTH / (PENDULUMS_COLUMNS + 1)
      local y = i * WINDOW_HEIGHT / (PENDULUMS_ROWS + 1) - ARM_LENGTH / 2

      local pendulum = Pendulum:new(x, y, angle)
      table.insert(pendulums, pendulum)
    end
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    for i, pendulum in ipairs(pendulums) do
      pendulum.angularVelocity = pendulum.angularVelocity * 1.1
    end
  end
end

function love.update(dt)
  for i, pendulum in ipairs(pendulums) do
    pendulum:update(dt)
  end
end

function love.draw()
  for i, pendulum in ipairs(pendulums) do
    pendulum:render()
  end
end
