Pellet = {}
Pellet.__index = Pellet

function Pellet:new()
  local x = math.random(0, WINDOW_WIDTH)
  local y = math.random(0, WINDOW_HEIGHT)

  local this = {
    ["x"] = x - PELLET_SIZE / 2,
    ["y"] = y - PELLET_SIZE / 2,
    ["size"] = PELLET_SIZE
  }

  setmetatable(this, self)
  return this
end

function Pellet:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.25)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(PELLET_LINE_WIDTH)
  love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
end
