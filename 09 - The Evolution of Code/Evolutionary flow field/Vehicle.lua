require "Field"

Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new(position)
  local field = Field:new()
  local position = position or LVector:new(math.random(WINDOW_WIDTH), math.random(WINDOW_HEIGHT))
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["maxSpeed"] = MAX_SPEED_VEHICLE,
    ["maxForce"] = MAX_FORCE_VEHICLE,
    ["size"] = SIZE_VEHICLE,
    ["angle"] = 0,
    ["field"] = field,
    ["lifespan"] = LIFESPAN_VEHICLE
  }

  setmetatable(this, self)
  return this
end

function Vehicle:update(dt)
  if self.lifespan > 0 then
    self.lifespan = self.lifespan - dt * UPDATE_SPEED
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

    self:navigate(self.field)
  end
end

function Vehicle:render()
  -- the idea is to eventually render a single field, for the vehicle describing the best fit
  self.field:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(self.lifespan, 8, 8)

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

function Vehicle:navigate(field)
  local force = field:lookup(self.position.x, self.position.y).force
  force:limit(self.maxForce)
  self:applyForce(force)
end
