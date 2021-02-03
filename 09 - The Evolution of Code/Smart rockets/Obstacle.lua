Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:new(x, y, width, height)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height
  }

  setmetatable(this, self)
  return this
end

function Obstacle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
