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

function Vehicle:seek(position)
  local desiredVelocity = LVector:subtract(position, self.position)
  desiredVelocity:normalize()
  desiredVelocity:multiply(self.maxSpeed)

  local force = LVector:subtract(desiredVelocity, self.velocity)
  force:limit(self.maxForce)

  self:applyForce(force)
end

function Vehicle:follow(path)
  local velocity = LVector:copy(self.velocity)
  velocity:normalize()
  velocity:multiply(DESIRED_LOCATION_DISTANCE)
  local desiredLocation = LVector:add(self.position, velocity)

  local recordDistance = math.huge
  local recordProjection = nil
  for i, segment in ipairs(path.segments) do
    local a = LVector:subtract(desiredLocation, segment.start)
    local b = LVector:subtract(segment.finish, segment.start)
    b:normalize()
    b:multiply(TARGET_MULTIPLIER)
    local projection = LVector:multiply(b, LVector:dot(a, b))
    projection:add(segment.start)

    if projection.x > segment.start.x and projection.x < segment.finish.x then
      local dir = LVector:subtract(projection, desiredLocation)
      local distance = dir:getMagnitude()
      if distance > RADIUS_PATH and distance < recordDistance then
        recordDistance = distance
        recordProjection = projection
      end
    end
  end

  if recordProjection then
    self:seek(recordProjection)
  end
end
