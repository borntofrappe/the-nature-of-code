LVector = require "LVector"
require "Vehicle"
require "Target"

WINDOW_WIDTH = 600
WINDOW_HEIGHT = 400
SIZE_VEHICLE = 8
MAX_SPEED = 20
MAX_FORCE = 10
UPDATE_SPEED = 8
VELOCITY_MIN = 10
VELOCITY_MAX = 30
DISTANCE_VEHICLE = 30
VEHICLES = 7
RADIUS_TARGET = 8
LINE_WIDTH_TARGET = 2
STEERING_MULTIPLIER = 1
SEPARATION_MULTIPLIER = 3

function love.load()
  love.window.setTitle("Autonomous Agents - Combining behaviors - Steering and separation")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  vehicles = {}
  for i = 1, VEHICLES do
    table.insert(vehicles, Vehicle:new())
  end

  target = Target:new()
end

function love.mousepressed(x, y, button)
  if button == 2 then
    target.isVisible = not target.isVisible
  end
end

function love.update(dt)
  for i, vehicle in ipairs(vehicles) do
    vehicle:update(dt)

    vehicle:applyBehaviors(vehicles, target)

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

  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    local position = LVector:new(x, y)
    table.insert(vehicles, Vehicle:new(position))
  end

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local position = LVector:new(x, y)
    target.position = position
  end
end

function love.draw()
  target:render()
  for i, vehicle in ipairs(vehicles) do
    vehicle:render()
  end
end
