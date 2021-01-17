Circle = {}
Circle.__index = Circle

function Circle:new(world, x, y, r, type)
  local body = love.physics.newBody(world, x, y, type)
  local shape = love.physics.newCircleShape(r)
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

function Circle:applyForce(fx, fy)
  self.body:applyForce(fx, fy)
end

function Circle:attract(particle)
  local dx = self.body:getX() - particle.body:getX()
  local dy = self.body:getY() - particle.body:getY()

  local magnitude = (dx ^ 2 + dy ^ 2) ^ 0.5
  dx = dx / magnitude * GRAVITATIONAL_FORCE
  dy = dy / magnitude * GRAVITATIONAL_FORCE

  return dx, dy
end
