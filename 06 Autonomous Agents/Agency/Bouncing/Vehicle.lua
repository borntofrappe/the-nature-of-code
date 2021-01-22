Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new()
  local position = LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  local vx = math.random(VELOCITY_MIN, VELOCITY_MAX)
  local vy = math.random(VELOCITY_MIN, VELOCITY_MAX)
  if math.random() > 0.5 then
    vx = vx * -1
  end
  if math.random() > 0.5 then
    vy = vy * -1
  end
  local velocity = LVector:new(vx, vy)

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
