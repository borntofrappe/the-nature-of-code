Turtle = {}
Turtle.__index = Turtle

function Turtle:new(stepLength, angle, sentence, generation)
  local ruleset = {
    ["F"] = function()
      love.graphics.line(0, 0, stepLength, 0)
      love.graphics.translate(stepLength, 0)
    end,
    ["G"] = function()
      love.graphics.translate(stepLength, 0)
    end,
    ["+"] = function()
      love.graphics.rotate(angle)
    end,
    ["-"] = function()
      love.graphics.rotate(angle * -1)
    end,
    ["["] = function()
      love.graphics.push()
    end,
    ["]"] = function()
      love.graphics.pop()
    end
  }

  local this = {
    ["ruleset"] = ruleset,
    ["stepLength"] = stepLength,
    ["angle"] = angle,
    ["sentence"] = sentence,
    ["generation"] = generation or 1
  }

  setmetatable(this, self)
  return this
end

function Turtle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.5)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.translate(0, WINDOW_HEIGHT)
  for i = 1, #self.sentence do
    self.ruleset[self.sentence:sub(i, i)]()
  end
end
