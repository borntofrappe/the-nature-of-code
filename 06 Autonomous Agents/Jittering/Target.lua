Target = {}
Target.__index = Target

function Target:new(position)
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["r"] = RADIUS_TARGET,
    ["maxForce"] = MAX_FORCE_TARGET,
    ["satellite"] = {
      ["isVisible"] = false,
      ["distance"] = DISTANCE_SATELLITE,
      ["angle"] = 0,
      ["r"] = RADIUS_SATELLITE
    }
  }

  setmetatable(this, self)
  return this
end

function Target:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt * UPDATE_SPEED))
  self.velocity:add(LVector:multiply(self.acceleration, dt * UPDATE_SPEED))
  self.acceleration:multiply(0)

  self.satellite.angle = (self.satellite.angle + dt * UPDATE_SPEED_ANGLE) % (math.pi * 2)
end

function Target:render()
  love.graphics.push()
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.setColor(0.11, 0.11, 0.11, 0.2)
  love.graphics.circle("fill", 0, 0, self.r)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH_TARGET)
  love.graphics.circle("line", 0, 0, self.r)

  if self.satellite.isVisible then
    love.graphics.rotate(self.satellite.angle)
    love.graphics.translate(self.r + self.satellite.distance, 0)
    love.graphics.setColor(0.11, 0.11, 0.11, 1)
    love.graphics.circle("fill", 0, 0, self.satellite.r)
  end
  love.graphics.pop()
end

function Target:applyForce(force)
  self.acceleration:add(force)
end

function Target:moveTowards(position)
  local desiredVelocity = LVector:subtract(position, self.position)
  local force = LVector:subtract(desiredVelocity, self.velocity)
  force:multiply(self.maxForce)
  self:applyForce(force)
end
