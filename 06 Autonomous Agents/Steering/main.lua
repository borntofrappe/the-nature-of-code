LVector = require "LVector"
require "Vehicle"
require "Target"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS_VEHICLE = 7
RADIUS_TARGET = 15
LINE_WIDTH_TARGET = 3
MAX_SPEED = 15
FORCE_COEFFICIENT = 0.1
UPDATE_SPEED = 15

function love.load()
  love.window.setTitle("Autonomous Agents - Steering")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  local xVehicle = WINDOW_WIDTH / 4
  local yVehicle = WINDOW_HEIGHT / 2
  local xTarget = WINDOW_WIDTH * 3 / 4
  local yTarget = math.random(math.floor(WINDOW_HEIGHT / 4), math.floor(WINDOW_HEIGHT * 3 / 4))
  local positionVehicle = LVector:new(xVehicle, yVehicle)
  local positionTarget = LVector:new(xTarget, yTarget)

  vehicle = Vehicle:new(positionVehicle)
  target = Target:new(positionTarget)
end

function love.update(dt)
  vehicle:update(dt)
  vehicle:steer(target)

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local position = LVector:new(x, y)
    target.position = position
  end
end

function love.draw()
  vehicle:render()
  target:render()
end
