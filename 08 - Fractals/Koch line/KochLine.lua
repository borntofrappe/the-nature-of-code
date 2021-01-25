require "Line"
KochLine = {}
KochLine.__index = KochLine

function KochLine:new(position)
  local start = LVector:new(PADDING, WINDOW_HEIGHT - PADDING)
  local finish = LVector:new(WINDOW_WIDTH - PADDING, WINDOW_HEIGHT - PADDING)
  local lines = {Line:new(start, finish)}

  local this = {
    ["lines"] = lines,
    ["newLines"] = {}
  }

  setmetatable(this, self)
  return this
end

function KochLine:generate()
  for i, line in ipairs(self.lines) do
    local a, b, c, d, e = self:getPoints(line)
    table.insert(self.newLines, Line:new(a, b))
    table.insert(self.newLines, Line:new(b, c))
    table.insert(self.newLines, Line:new(c, d))
    table.insert(self.newLines, Line:new(d, e))
  end

  self.lines = {}
  for i, line in ipairs(self.newLines) do
    table.insert(self.lines, line)
  end

  self.newLines = {}
end

function KochLine:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH)

  for i, line in ipairs(self.lines) do
    line:render()
  end
end

function KochLine:getPoints(line)
  local segment = LVector:subtract(line.finish, line.start)
  local third = LVector:divide(segment, 3)

  local a = LVector:copy(line.start)
  local b = LVector:add(line.start, third)

  local c = LVector:copy(line.start)
  local thirdC = LVector:copy(third)
  c:add(thirdC)
  thirdC:rotate(math.rad(60) * -1)
  c:add(thirdC)

  local d = LVector:add(line.start, LVector:multiply(third, 2))
  local e = LVector:copy(line.finish)

  return a, b, c, d, e
end
