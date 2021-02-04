Point = {}
Point.__index = Point

function Point:new()
  local x = math.random(POINT_RADIUS, WINDOW_WIDTH - POINT_RADIUS)
  local y = math.random(POINT_RADIUS, WINDOW_HEIGHT - POINT_RADIUS)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = POINT_RADIUS,
    ["lineWidth"] = POINT_LINE_WIDTH,
    ["label"] = x > y and 1 or -1
  }

  setmetatable(this, self)
  return this
end

function Point:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(self.lineWidth)
  if self.label == 1 then
    love.graphics.circle("fill", self.x, self.y, self.r + self.lineWidth)
  else
    love.graphics.circle("line", self.x, self.y, self.r)
  end
end
