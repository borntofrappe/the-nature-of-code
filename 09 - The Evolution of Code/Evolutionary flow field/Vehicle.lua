Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new()
  local position = LVector:new(X_VEHICLE, Y_VEHICLE)
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)
  local field = Field:new()
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["maxSpeed"] = MAX_SPEED_VEHICLE,
    ["maxForce"] = MAX_FORCE_VEHICLE,
    ["size"] = SIZE_VEHICLE,
    ["angle"] = 0,
    ["field"] = field
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

  if self.position.x > WINDOW_WIDTH then
    self.position.x = 0
  elseif self.position.x < 0 then
    self.position.x = WINDOW_WIDTH
  end
  if self.position.y > WINDOW_HEIGHT then
    self.position.y = 0
  elseif self.position.y < 0 then
    self.position.y = WINDOW_HEIGHT
  end

  self:navigateField()
end

function Vehicle:render()
  -- self.field:render()
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

function Vehicle:navigateField()
  local force = self.field:lookup(self.position.x, self.position.y).force
  force:limit(self.maxForce)
  self:applyForce(force)
end
