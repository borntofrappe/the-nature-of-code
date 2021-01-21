LVector = require "LVector"
require "Vehicle"
require "Path"

WINDOW_WIDTH = 600
WINDOW_HEIGHT = 400
SIZE_VEHICLE = 8
MAX_SPEED = 40
MAX_FORCE = 10
UPDATE_SPEED = 5
RADIUS_PATH = 20
LINE_WIDTH_PATH = 2
VELOCITY_MIN = 5
VELOCITY_MAX = 15
HEIGHT_MIN = WINDOW_HEIGHT / 4
HEIGHT_MAX = WINDOW_HEIGHT * 3 / 4
LOCATION_DISTANCE = 20
TARGET_MULTIPLIER = 1.1
VEHICLES = 7

function love.load()
  love.window.setTitle("Autonomous Agents - Path following")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  vehicles = {}
  for i = 1, VEHICLES do
    table.insert(vehicles, Vehicle:new())
  end

  path = Path:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local position = LVector:new(x, y)
    table.insert(vehicles, Vehicle:new(position))
  --add vehicle at x y
  end

  if button == 2 then
    path.start.y = math.random(HEIGHT_MIN, HEIGHT_MAX)
    path.finish.y = math.random(HEIGHT_MIN, HEIGHT_MAX)
  end
end

function love.update(dt)
  for i, vehicle in ipairs(vehicles) do
    vehicle:update(dt)
    vehicle:follow(path)

    if vehicle.position.x < -vehicle.size then
      vehicle.position.x = WINDOW_WIDTH + vehicle.size
    elseif vehicle.position.x > WINDOW_WIDTH + vehicle.size then
      vehicle.position.x = -vehicle.size
    end

    if vehicle.position.y < -vehicle.size then
      vehicle.position.y = WINDOW_HEIGHT + vehicle.size
    elseif vehicle.position.y > WINDOW_HEIGHT + vehicle.size then
      vehicle.position.y = -vehicle.size
    end
  end
end

function love.draw()
  path:render()
  for i, vehicle in ipairs(vehicles) do
    vehicle:render()
  end
end
