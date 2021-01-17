Circle = {}
Circle.__index = Circle

function Circle:new(world, x, y)
  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newCircleShape(RADIUS)
  local fixture = love.physics.newFixture(body, shape)

  local this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  setmetatable(this, self)
  return this
end

function Circle:render()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end
