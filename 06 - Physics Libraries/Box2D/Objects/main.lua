WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRAVITY = 20
METER = 60
RADIUS = 10

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Objects")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  objects = {}

  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * 9.81)
end

function love.update(dt)
  world:update(dt)

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local body = love.physics.newBody(world, x, y, "dynamic")
    local shape = love.physics.newCircleShape(RADIUS)
    local fixture = love.physics.newFixture(body, shape)
    local object = {
      ["body"] = body,
      ["shape"] = shape,
      ["fixture"] = fixture
    }
    table.insert(objects, object)
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11)
  for i, object in ipairs(objects) do
    love.graphics.circle("fill", object.body:getX(), object.body:getY(), object.shape:getRadius())
  end
end
