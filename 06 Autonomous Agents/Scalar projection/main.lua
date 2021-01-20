LVector = require "LVector"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS_ORIGIN = 6
RADIUS_DESTINATION = 4
RADIUS_CIRCLE = 200
LINE_WIDTH = 2
LINE_LENGTH = math.floor(WINDOW_WIDTH / 2)
LINE_Y_MAX = math.floor(WINDOW_HEIGHT / 2)

function love.load()
  love.window.setTitle("Autonomous Agents - Scalar projection")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  origin = LVector:new(WINDOW_WIDTH / 4, WINDOW_HEIGHT * 3 / 4)
  a = LVector:new(0, 0)
  b = LVector:new(LINE_LENGTH, math.random(LINE_Y_MAX) * -1)
  projection = LVector:new(0, 0)
  math.randomseed(os.time())
end

function love.mousepressed(x, y, button)
  if button == 1 then
    b.y = math.random(LINE_Y_MAX) * -1
  end
end

function love.update(dt)
  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local point = LVector:new(x, y)
    local distance = LVector:subtract(point, origin)
    a = distance

    local b = LVector:copy(b)
    b:normalize()
    projection = LVector:multiply(b, LVector:dot(a, b))
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.circle("fill", origin.x, origin.y, RADIUS_ORIGIN)
  love.graphics.line(origin.x, origin.y, origin.x + a.x, origin.y + a.y)
  love.graphics.circle("fill", origin.x + a.x, origin.y + a.y, RADIUS_DESTINATION)
  love.graphics.line(origin.x, origin.y, origin.x + b.x, origin.y + b.y)
  love.graphics.circle("fill", origin.x + b.x, origin.y + b.y, RADIUS_DESTINATION)

  love.graphics.setColor(0.11, 0.11, 0.11, 0.25)
  love.graphics.line(origin.x + a.x, origin.y + a.y, origin.x + projection.x, origin.y + projection.y)
  love.graphics.setColor(0.87, 0.07, 0.21, 1)
  love.graphics.circle("fill", origin.x + projection.x, origin.y + projection.y, RADIUS_DESTINATION)
end
