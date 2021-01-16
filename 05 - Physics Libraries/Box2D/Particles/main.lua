WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRAVITY = 20
GRAVITY_METER = 9.81
METER = 100
RADIUS = 6
SIZE = 10

require "Rectangle"
require "Circle"

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Particles")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * GRAVITY_METER)
  particles = {}

  origin = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2
  }
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
end
