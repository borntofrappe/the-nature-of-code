WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRAVITY = 20
GRAVITY_METER = 9.81
METER = 100
RADIUS = 6
SIZE = 10
PLATFORM_WIDTH = 300
PLATFORM_HEIGHT = 10
POINT_SIZE = 5
LINE_WIDTH = 1

require "Rectangle"
require "Circle"
require "Platform"

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Fixed")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * GRAVITY_METER)
  particles = {}

  origin = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2
  }

  platforms = {
    Platform:new(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4, PLATFORM_WIDTH, PLATFORM_HEIGHT)
  }

  mouse = {
    ["isPressed"] = false,
    ["x1"] = 0,
    ["y1"] = 0,
    ["x2"] = 0,
    ["y2"] = 0
  }
end

function love.mousepressed(x, y, button)
  if button == 1 then
    mouse.isPressed = true
    mouse.x1 = x
    mouse.y1 = y
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    mouse.isPressed = false
    local x = math.min(mouse.x1, mouse.x2)
    local y = math.min(mouse.y1, mouse.y2)
    local width = math.abs(mouse.x1 - mouse.x2)
    local height = math.abs(mouse.y1 - mouse.y2)
    table.insert(platforms, Platform:new(world, x + width / 2, y + height / 2, width, height))
  end
end

function love.update(dt)
  world:update(dt)

  local isSquare = math.random() > 0.5
  if isSquare then
    table.insert(particles, Rectangle:new(world, origin.x, origin.y))
  else
    table.insert(particles, Circle:new(world, origin.x, origin.y))
  end

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    origin.x = x
    origin.y = y

    if mouse.isPressed then
      mouse.x2 = x
      mouse.y2 = y
    end
  end

  for i = #particles, 1, -1 do
    if particles[i].body:getY() - SIZE > WINDOW_HEIGHT then
      particles[i].body:destroy()
      table.remove(particles, i)
    end
  end
end

function love.draw()
  for i, particle in ipairs(particles) do
    particle:render()
  end

  for i, platform in ipairs(platforms) do
    platform:render()
  end

  if mouse.isPressed then
    love.graphics.setColor(0.11, 0.11, 0.11)
    love.graphics.setPointSize(POINT_SIZE)
    love.graphics.points(mouse.x1, mouse.y1, mouse.x2, mouse.y2)
    love.graphics.setLineWidth(LINE_WIDTH)
    love.graphics.line(mouse.x1, mouse.y1, mouse.x2, mouse.y1)
    love.graphics.line(mouse.x1, mouse.y1, mouse.x1, mouse.y2)
    love.graphics.line(mouse.x2, mouse.y1, mouse.x2, mouse.y2)
    love.graphics.line(mouse.x1, mouse.y2, mouse.x2, mouse.y2)
  end
end
