LVector = require "LVector"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS_ORIGIN = 6
RADIUS_DESTINATION = 4
RADIUS_CIRCLE = 200
LINE_WIDTH = 2

function love.load()
  love.window.setTitle("Autonomous Agents - Dot product")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  origin = LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  a = LVector:new(RADIUS_CIRCLE, 0)
  b = LVector:new(RADIUS_CIRCLE, 0)
  math.randomseed(os.time())
  angle = 0
end

function love.update(dt)
  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local point = LVector:new(x, y)
    local distance = LVector:subtract(point, origin)
    distance:normalize()
    distance:multiply(RADIUS_CIRCLE)
    b = distance
    -- local d = LVector:dot(a, b)
    -- angle = math.acos(d / (a:getMagnitude() * b:getMagnitude()))
    angle = LVector:angleBetween(a, b)
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(string.format("%.2f radians", angle), 8, 8)
  love.graphics.print(string.format("%.2f degrees", math.deg(angle)), 8, 24)

  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.circle("fill", origin.x, origin.y, RADIUS_ORIGIN)
  love.graphics.line(origin.x, origin.y, origin.x + a.x, origin.y + a.y)
  love.graphics.circle("fill", origin.x + a.x, origin.y + a.y, RADIUS_DESTINATION)
  love.graphics.line(origin.x, origin.y, origin.x + b.x, origin.y + b.y)
  love.graphics.circle("fill", origin.x + b.x, origin.y + b.y, RADIUS_DESTINATION)
end
