Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new()
  local position = LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  local velocity = LVector:new(20, 10)
  local acceleration = LVector:new(0, 0)
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["maxSpeed"] = MAX_SPEED,
    ["maxForce"] = MAX_FORCE,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

function Vehicle:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt * UPDATE_SPEED))
  self.velocity:add(LVector:multiply(self.acceleration, dt * UPDATE_SPEED))
  self.velocity:limit(self.maxSpeed)
  self.acceleration:multiply(0)
end

function Vehicle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Vehicle:applyForce(force)
  self.acceleration:add(force)
end

function Vehicle:moveWithin(boundary)
  local desiredVelocity = LVector:copy(self.velocity)
  local position = LVector:add(desiredVelocity, self.position)
  if position.x < boundary.x then
    self:applyForce(LVector:new(BOUNCE_FORCE, 0))
  elseif position.x > boundary.x + boundary.width then
    self:applyForce(LVector:new(-BOUNCE_FORCE, 0))
  elseif position.y < boundary.y then
    self:applyForce(LVector:new(0, BOUNCE_FORCE))
  elseif position.y > boundary.y + boundary.height then
    self:applyForce(LVector:new(0, -BOUNCE_FORCE))
  else
    self:applyForce(desiredVelocity)
  end
end
