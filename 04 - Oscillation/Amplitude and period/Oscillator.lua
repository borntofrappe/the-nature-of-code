Oscillator = {}
Oscillator.__index = Oscillator

function Oscillator:new()
  local this = {
    ["x"] = 0,
    ["y"] = 0,
    ["size"] = SIZE,
    ["frameCount"] = 0
  }

  setmetatable(this, self)
  return this
end

function Oscillator:update(dt)
  self.frameCount = (self.frameCount + dt * UPDATE_SPEED) % PERIOD
  self.x = AMPLITUDE * math.cos(math.pi * 2 * (self.frameCount / PERIOD))
end

function Oscillator:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.5)
  love.graphics.setLineWidth(1)
  love.graphics.line(0, 0, self.x, self.y)

  love.graphics.push()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.translate(self.x, self.y)
  love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)
  love.graphics.pop()
end
