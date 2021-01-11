Mover = {}
Mover.__index = Mover

function Mover:new()
  local angle = LVector:new(0, 0)

  local vx = math.random(ANGULAR_VELOCITY_MIN, ANGULAR_VELOCITY_MAX)
  local vy = math.random(ANGULAR_VELOCITY_MIN, ANGULAR_VELOCITY_MAX)
  if math.random() > 0.5 then
    vx = vx * -1
  end
  if math.random() > 0.5 then
    vy = vy * -1
  end
  local angularVelocity = LVector:new(vx, vy)

  local ax = math.random(AMPLITUDE_MIN, AMPLITUDE_MAX)
  local ay = math.random(AMPLITUDE_MIN, AMPLITUDE_MAX)
  local amplitude = LVector:new(ax, ay)

  this = {
    ["x"] = 0,
    ["y"] = 0,
    ["r"] = RADIUS,
    ["angle"] = angle,
    ["amplitude"] = amplitude,
    ["angularVelocity"] = angularVelocity
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.angle:add(LVector:multiply(self.angularVelocity, dt))

  self.x = self.amplitude.x * math.sin(self.angle.x)
  self.y = self.amplitude.y * math.sin(self.angle.y)
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
