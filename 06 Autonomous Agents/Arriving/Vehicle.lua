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
    ["forceCoefficient"] = FORCE_COEFFICIENT,
    ["r"] = RADIUS_VEHICLE
  }

  setmetatable(this, self)
  return this
end

function Vehicle:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt * UPDATE_SPEED))
  self.velocity:add(LVector:multiply(self.acceleration, dt * UPDATE_SPEED))
  self.acceleration:multiply(0)
end

function Vehicle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Vehicle:applyForce(force)
  self.acceleration:add(force)
end

function Vehicle:steer(target)
  local desiredVelocity = LVector:subtract(target.position, self.position)
  local distance = desiredVelocity:getMagnitude()

  if distance > RADIUS_SLOWDOWN then
    desiredVelocity:limit(self.maxSpeed)
  else
    desiredVelocity:limit(map(distance, 0, RADIUS_SLOWDOWN, 0, self.maxSpeed))
  end

  local steeringForce = LVector:subtract(desiredVelocity, self.velocity)
  steeringForce:multiply(self.forceCoefficient)
  self:applyForce(steeringForce)
end
