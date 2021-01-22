Boundary = {}
Boundary.__index = Boundary

function Boundary:new()
  local this = {
    ["x"] = PADDING_BOUNDARY,
    ["y"] = PADDING_BOUNDARY,
    ["width"] = WINDOW_WIDTH - PADDING_BOUNDARY * 2,
    ["height"] = WINDOW_HEIGHT - PADDING_BOUNDARY * 2,
    ["isVisible"] = true
  }

  setmetatable(this, self)
  return this
end

function Boundary:render()
  if self.isVisible then
    love.graphics.setColor(0.11, 0.11, 0.11, 1)
    love.graphics.setLineWidth(LINE_WIDTH_BOUNDARY)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
  end
end
