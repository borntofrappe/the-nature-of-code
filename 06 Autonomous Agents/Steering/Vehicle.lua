Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new(position)
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["maxSpeed"] = MAX_SPEED,
    ["maxForce"] = MAX_FORCE,
    ["size"] = SIZE_VEHICLE,
    ["angle"] = 0
  }

  setmetatable(this, self)
  return this
end

function Vehicle:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt * UPDATE_SPEED))
  self.velocity:add(LVector:multiply(self.acceleration, dt * UPDATE_SPEED))
  self.velocity:limit(self.maxSpeed)
  self.acceleration:multiply(0)
  self.angle = math.atan2(self.velocity.y, self.velocity.x)
end

function Vehicle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.push()
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.rotate(self.angle)
  love.graphics.polygon("fill", -self.size, -self.size, self.size, 0, -self.size, self.size)
  love.graphics.pop()
end

function Vehicle:applyForce(force)
  self.acceleration:add(force)
end

function Vehicle:steer(target)
  local desiredVelocity = LVector:subtract(target.position, self.position)
  desiredVelocity:normalize()
  desiredVelocity:multiply(self.maxSpeed)

  local force = LVector:subtract(desiredVelocity, self.velocity)
  force:limit(self.maxForce)

  self:applyForce(force)
end
