Turtle = {}
Turtle.__index = Turtle

function Turtle:new(x, y, angle, sentence, generation)
  local ruleset = {
    ["F"] = function()
      love.graphics.line(0, 0, x, y)
      love.graphics.translate(x, y)
    end,
    ["G"] = function()
      love.graphics.translate(x, y)
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
    ["x"] = x,
    ["y"] = y,
    ["angle"] = angle,
    ["sentence"] = sentence,
    ["generation"] = generation or 1
  }

  setmetatable(this, self)
  return this
end

function Turtle:render()
  for i = 1, #self.sentence do
    self.ruleset[self.sentence:sub(i, i)]()
  end
end
