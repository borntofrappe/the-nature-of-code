Line = {}
Line.__index = Line

function Line:new(start, finish, angle)
  local this = {
    ["start"] = start,
    ["finish"] = finish,
    ["angle"] = angle or 0
  }

  setmetatable(this, self)
  return this
end

function Line:render()
  love.graphics.line(self.start.x, self.start.y, self.finish.x, self.finish.y)
end
