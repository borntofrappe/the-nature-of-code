require "Vector"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_MIN = 50
VELOCITY_MAX = 150
RADIUS = 5
LINE_WIDTH = 1

function love.load()
  love.window.setTitle("Vectors - 2D Library")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  position = Vector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  local vx = math.random(VELOCITY_MIN, VELOCITY_MAX)
  local vy = math.random(VELOCITY_MIN, VELOCITY_MAX)
  if math.random() > 0.5 then
    vx = vx * -1
  end
  if math.random() > 0.5 then
    vy = vy * -1
  end
  velocity = Vector:new(vx, vy)

  angle = math.atan(velocity.y / velocity.x)
  if velocity.x < 0 then
    angle = angle + math.pi
  end
end

function love.update(dt)
  local x, y = love.mouse:getPosition()
  if x > 0 and y > 0 then
    velocity.x = x - WINDOW_WIDTH / 2
    velocity.y = y - WINDOW_HEIGHT / 2

    angle = math.atan(velocity.y / velocity.x)
    if velocity.x < 0 then
      angle = angle + math.pi
    end
  end
end

function love.draw()
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.setColor(0.11, 0.11, 0.11, 0.2)
  love.graphics.line(position.x, position.y, position.x + velocity.x, position.y + velocity.y)

  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", position.x, position.y, RADIUS)

  love.graphics.translate(position.x + velocity.x, position.y + velocity.y)
  love.graphics.rotate(angle)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.polygon("fill", 0, -8, 8, 0, 0, 8)
end
