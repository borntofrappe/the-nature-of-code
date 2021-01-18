Target = {}
Target.__index = Target

function Target:new(position)
  local this = {
    ["position"] = position,
    ["r"] = RADIUS_TARGET
  }

  setmetatable(this, self)
  return this
end

function Target:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.2)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH_TARGET)
  love.graphics.circle("line", self.position.x, self.position.y, self.r)
end
