LVector = require "LVector"
require "Vehicle"
require "Target"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 500

VEHICLES = 1
SIZE_VEHICLE = 8
LIFESPAN_VEHICLE = 100
MAX_SPEED_VEHICLE = 15
MAX_FORCE_VEHICLE = 2

RESOLUTION_FLOW_FIELD = 20
LINE_WIDTH_FLOW_FIELD = 0.5

RADIUS_TARGET = 10

UPDATE_SPEED = 15

function love.load()
  love.window.setTitle("The evolution of code - Not so random flow field")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  target = Target:new()

  vehicles = {}
  for i = 1, VEHICLES do
    table.insert(vehicles, Vehicle:new())
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local position = LVector:new(x, y)
    target.position = position
  end
end

function love.update(dt)
  for i, vehicle in ipairs(vehicles) do
    vehicle:update(dt)
  end
end

function love.draw()
  target:render()
  for i, vehicle in ipairs(vehicles) do
    vehicle:render()
  end
end
