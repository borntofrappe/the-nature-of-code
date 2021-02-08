Point = {}
Point.__index = Point

function Point:new()
  local x = math.random() * 2 - 1
  local y = math.random() * 2 - 1

  local this = {
    ["inputs"] = {x, y, 1},
    ["x"] = map(x, -1, 1, 0, WINDOW_WIDTH),
    ["y"] = map(y, -1, 1, WINDOW_HEIGHT, 0),
    ["r"] = POINT_RADIUS,
    ["lineWidth"] = POINT_LINE_WIDTH,
    ["label"] = f(x) > y and 1 or -1
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
