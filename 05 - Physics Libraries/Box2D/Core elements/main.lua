WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRAVITY = 20
GRAVITY_METER = 9.81
METER = 60
RADIUS = 6

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Core elements")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * GRAVITY_METER)

  body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, "dynamic")
  shape = love.physics.newCircleShape(RADIUS)
  fixture = love.physics.newFixture(body, shape)
end

function love.update(dt)
  world:update(dt)

  if not body:isDestroyed() and body:getY() - shape:getRadius() > WINDOW_HEIGHT then
    body:destroy()
    body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, "dynamic")
    shape = love.physics.newCircleShape(RADIUS)
    fixture = love.physics.newFixture(body, shape)
  end
end

function love.draw()
  if not body:isDestroyed() then
    love.graphics.setColor(0.11, 0.11, 0.11)
    love.graphics.circle("fill", body:getX(), body:getY(), shape:getRadius())
  end
end
