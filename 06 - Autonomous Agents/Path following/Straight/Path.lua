Path = {}
Path.__index = Path

function Path:new()
  local x1 = -RADIUS_PATH
  local x2 = WINDOW_WIDTH + RADIUS_PATH
  local y1 = math.random(HEIGHT_MIN, HEIGHT_MAX)
  local y2 = math.random(HEIGHT_MIN, HEIGHT_MAX)
  local start = LVector:new(x1, y1)
  local finish = LVector:new(x2, y2)
  local this = {
    ["r"] = RADIUS_PATH,
    ["lineWidth"] = LINE_WIDTH_PATH,
    ["start"] = start,
    ["finish"] = finish
  }

  setmetatable(this, self)
  return this
end

function Path:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.1)
  love.graphics.setLineWidth(self.r * 2)
  love.graphics.line(self.start.x, self.start.y, self.finish.x, self.finish.y)

  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.line(self.start.x, self.start.y, self.finish.x, self.finish.y)
end
