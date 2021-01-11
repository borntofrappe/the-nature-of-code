Mover = {}
Mover.__index = Mover

function Mover:new()
  this = {
    ["x"] = 0,
    ["y"] = 0,
    ["size"] = SIZE,
    ["frameCount"] = 0
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.frameCount = (self.frameCount + dt * UPDATE_SPEED) % PERIOD
  self.x = AMPLITUDE * math.cos(math.pi * 2 * (self.frameCount / PERIOD))
end

function Mover:render()
  love.graphics.push()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.translate(self.x, self.y)
  love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)
  love.graphics.pop()
end
