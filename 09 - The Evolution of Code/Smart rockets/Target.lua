Target = {}
Target.__index = Target

function Target:new(x, y)
  local position = LVector:new(x, y)

  local this = {
    ["position"] = position,
    ["r"] = TARGET_RADIUS
  }

  setmetatable(this, self)
  return this
end

function Target:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
