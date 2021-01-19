Boundary = {}
Boundary.__index = Boundary

function Boundary:new()
  local this = {
    ["x"] = PADDING,
    ["y"] = PADDING,
    ["width"] = WINDOW_WIDTH - PADDING * 2,
    ["height"] = WINDOW_HEIGHT - PADDING * 2
  }

  setmetatable(this, self)
  return this
end

function Boundary:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH_BOUNDARY)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
