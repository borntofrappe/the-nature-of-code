LVector = require "LVector"
require "Vehicle"
require "Target"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SIZE_VEHICLE = 8
RADIUS_TARGET = 12
DISTANCE_TARGET = 200
LINE_WIDTH_TARGET = 3
MAX_SPEED = 20
MAX_FORCE_VEHICLE = 2
MAX_FORCE_TARGET = 0.5
VELOCITY_MULTIPLIER = 3
UPDATE_SPEED = 10

function love.load()
  love.window.setTitle("Autonomous Agents - Pursuing")
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

  showDesire = false
end

function love.mousepressed(x, y, button)
  if button == 1 then
    showDesire = not showDesire
  end
end

function love.update(dt)
  vehicle:update(dt)
  target:update(dt)

  vehicle:pursue(target)

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local position = LVector:new(x, y)
    target:moveTowards(position)
  end
end

function love.draw()
  vehicle:render()
  target:render()
  if showDesire then
    local position = LVector:add(target.position, LVector:multiply(target.velocity, VELOCITY_MULTIPLIER))
    love.graphics.setColor(0.11, 0.11, 0.11, 1)
    love.graphics.circle("fill", position.x, position.y, 5)
  end
end
