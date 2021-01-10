Mover = {}
Mover.__index = Mover

function Mover:new()
  this = {
    ["x"] = 0,
    ["y"] = 0,
    ["size"] = SIZE,
    ["distance"] = 0,
    ["angle"] = 0,
    ["direction"] = 1
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.angle = (self.angle + dt * UPDATE_SPEED_ANGLE) % (math.pi * 2)
  self.distance = self.distance + dt * self.direction * UPDATE_SPEED_DISTANCE

  if self.distance >= math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 2.5 then
    self.distance = math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 2.5
    self.direction = -1
  elseif self.distance <= 0 then
    self.distance = 0
    self.direction = 1
  end

  self.x = math.cos(self.angle) * self.distance
  self.y = math.sin(self.angle) * self.distance
end

function Mover:render()
  love.graphics.push()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)
  love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)
  love.graphics.pop()
end
