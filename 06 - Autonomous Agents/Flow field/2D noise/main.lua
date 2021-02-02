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
OFFSET_INITIAL_MAX = 1000
OFFSET_INCREMENT = 0.02
VEHICLES = 7

function love.load()
  love.window.setTitle("Autonomous Agents - Flow field - 2D noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  vehicles = {}
  for i = 1, VEHICLES do
    table.insert(vehicles, Vehicle:new())
  end

  field = Field:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local position = LVector:new(x, y)
    table.insert(vehicles, Vehicle:new(position))
  end
  if button == 2 then
    field.isVisible = not field.isVisible
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
