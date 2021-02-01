Target = {}
Target.__index = Target

function Target:new(position)
  local position = position or LVector:new(math.random(WINDOW_WIDTH), math.random(WINDOW_HEIGHT))
  local this = {
    ["position"] = position,
    ["r"] = RADIUS_TARGET
  }

  setmetatable(this, self)
  return this
end

function Target:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
