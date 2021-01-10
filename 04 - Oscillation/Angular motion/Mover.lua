Mover = {}
Mover.__index = Mover

function Mover:new()
  local width = math.random(WIDTH_MIN, WIDTH_MAX)
  local height = math.random(HEIGHT_MIN, HEIGHT_MAX)
  local x = math.random(width, WINDOW_WIDTH - width)
  local y = math.random(height, WINDOW_HEIGHT - height)
  local angle = math.rad(math.random(ANGLE_MIN, ANGLE_MAX))

  local angularVelocity = 0
  local angularAcceleration = ANGULAR_ACCELERATION
  if math.random() > 0.5 then
    angularAcceleration = angularAcceleration * -1
  end

  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["angle"] = angle,
    ["angularVelocity"] = angularVelocity,
    ["angularAcceleration"] = angularAcceleration
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.angle = self.angle + self.angularVelocity
  self.angularVelocity = self.angularVelocity + self.angularAcceleration

  self.angularVelocity =
    math.min(ANGULAR_VELOCITY_THRESHOLD, math.max(ANGULAR_VELOCITY_THRESHOLD * -1, self.angularVelocity))
end

function Mover:render()
  love.graphics.push()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)

  love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)

  love.graphics.setColor(0.13, 0.86, 0.72)
  love.graphics.circle("fill", 0, 0, 2)
  love.graphics.pop()
end
