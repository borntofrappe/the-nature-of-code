Cell = {}
Cell.__index = Cell

function Cell:new(c, r)
  local size = CELL_SIZE
  local x = (c - 1) * size
  local y = (r - 1) * size
  local state = math.random() > 0.5
  local previousState = state

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["state"] = state,
    ["previousState"] = previousState
  }

  setmetatable(this, self)
  return this
end

function Cell:toggle()
  self.state = not self.state
end

function Cell:wasAlive()
  return self.previousState
end

function Cell:setAlive(state)
  self.state = state
end

function Cell:update()
  self.previousState = self.state
end

function Cell:render()
  if self.state then
    if self.state == self.previousState then
      love.graphics.setColor(0.11, 0.11, 0.11, 1)
    else
      love.graphics.setColor(0.12, 0.25, 0.87, 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  else
    if self.state ~= self.previousState then
      love.graphics.setColor(0.87, 0.05, 0.36, 1)
      love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
    end
  end
end
