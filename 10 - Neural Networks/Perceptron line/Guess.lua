Guess = {}
Guess.__index = Guess

function Guess:new(x, y, isCorrect)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = GUESS_RADIUS,
    ["lineWidth"] = GUESS_LINE_WIDTH,
    ["isCorrect"] = isCorrect
  }

  setmetatable(this, self)
  return this
end

function Guess:render()
  love.graphics.setLineWidth(self.lineWidth)
  if self.isCorrect then
    love.graphics.setColor(0.03, 0.92, 0.27, 1)
  else
    love.graphics.setColor(0.74, 0.09, 0.14, 1)
  end
  love.graphics.circle("line", self.x, self.y, self.r)
end
