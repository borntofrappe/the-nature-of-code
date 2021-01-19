LVector = require "LVector"
require "Vehicle"
require "Field"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SIZE_VEHICLE = 8
RESOLUTION = 20
LINE_WIDTH_FIELD = 0.5
MAX_SPEED = 15
MAX_FORCE = 2
UPDATE_SPEED = 15

function love.load()
  love.window.setTitle("Autonomous Agents - Flow field")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  local position = LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  local vehicle = Vehicle:new(position)
  vehicles = {
    vehicle
  }
  field = Field:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local position = LVector:new(x, y)
    table.insert(vehicles, Vehicle:new(position))
  end
end

function love.update(dt)
  for i, vehicle in ipairs(vehicles) do
    vehicle:update(dt)
    vehicle:navigate(field)
  end
end

function love.draw()
  for i, vehicle in ipairs(vehicles) do
    vehicle:render()
  end
  field:render()
end
