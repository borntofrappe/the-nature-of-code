WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRAVITY = 20
GRAVITY_METER = 9.81
METER = 100
SIZE = 16
WALL_WIDTH_LEFT_RIGHT = 10
WIND_FORCE = 10

require "ComplexShape"
require "Rectangle"

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Forces")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * GRAVITY_METER)

  local leftWall = Rectangle:new(world, 0, WINDOW_HEIGHT / 2, WALL_WIDTH_LEFT_RIGHT, WINDOW_HEIGHT, "static")
  local rightWall =
    Rectangle:new(world, WINDOW_WIDTH, WINDOW_HEIGHT / 2, WALL_WIDTH_LEFT_RIGHT, WINDOW_HEIGHT, "static")

  walls = {leftWall, rightWall}

  particles = {}
end

function love.update(dt)
  world:update(dt)

  table.insert(
    particles,
    ComplexShape:new(world, math.random(SIZE, WINDOW_WIDTH - SIZE), math.random(SIZE, SIZE * 3) * -1)
  )

  if love.mouse.isDown(1) then
    for i, particle in ipairs(particles) do
      particle:applyForce(WIND_FORCE, 0)
    end
  elseif love.mouse.isDown(2) then
    for i, particle in ipairs(particles) do
      particle:applyForce(WIND_FORCE * -1, 0)
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
  for i, wall in ipairs(walls) do
    wall:render()
  end

  for i, particle in ipairs(particles) do
    particle:render()
  end
end
