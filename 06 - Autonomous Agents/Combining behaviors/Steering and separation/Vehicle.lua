Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new(position)
  local position = position or LVector:new(math.random(WINDOW_WIDTH), math.random(WINDOW_HEIGHT))

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
    ["angle"] = 0,
    ["id"] = math.random()
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

function Vehicle:separate(vehicles)
  local separationForce = LVector:new(0, 0)
  for i, vehicle in ipairs(vehicles) do
    local distance = LVector:distance(vehicle.position, self.position)
    if distance < DISTANCE_VEHICLE and vehicle.id ~= self.id then
      local force = LVector:subtract(self.position, vehicle.position)
      force:divide(distance)
      separationForce:add(force)
    end
  end
  separationForce:normalize()
  separationForce:multiply(MAX_SPEED)
  return separationForce
end

function Vehicle:steer(target)
  local desiredVelocity = LVector:subtract(target.position, self.position)
  desiredVelocity:normalize()
  desiredVelocity:multiply(self.maxSpeed)

  local steeringForce = LVector:subtract(desiredVelocity, self.velocity)
  steeringForce:limit(self.maxForce)

  return steeringForce
end

function Vehicle:applyBehaviors(vehicles, target)
  local steeringForce = self:steer(target)
  local separationForce = self:separate(vehicles)

  steeringForce:multiply(STEERING_MULTIPLIER)
  separationForce:multiply(SEPARATION_MULTIPLIER)

  self:applyForce(steeringForce)
  self:applyForce(separationForce)
end
