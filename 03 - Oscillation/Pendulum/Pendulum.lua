Pendulum = {}
Pendulum.__index = Pendulum

function Pendulum:new(x, y, angle)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["angle"] = angle,
    ["angularVelocity"] = 0,
    ["angularAcceleration"] = 0
  }

  setmetatable(this, self)
  return this
end

function Pendulum:update(dt)
  self.angle = self.angle + self.angularVelocity * dt * UPDATE_SPEED
  self.angularVelocity = self.angularVelocity + self.angularAcceleration * dt * UPDATE_SPEED

  self.angularVelocity = self.angularVelocity * DAMPING
  self.angularAcceleration = math.sin(self.angle) * GRAVITY / ARM_LENGTH * dt * -1
end

function Pendulum:render()
  love.graphics.push()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(ARM_LINE_WIDTH)
  love.graphics.translate(self.x, self.y)
  love.graphics.circle("fill", 0, 0, PIVOT_RADIUS)

  love.graphics.rotate(self.angle)
  love.graphics.line(0, 0, 0, ARM_LENGTH)

  love.graphics.translate(0, ARM_LENGTH)
  love.graphics.circle("fill", 0, 0, BOB_RADIUS)
  love.graphics.pop()
end
