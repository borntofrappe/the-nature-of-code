Mover = {}
Mover.__index = Mover

function Mover:new()
  this = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

function Mover:randomWalk(normalNumbers)
  local indexX = math.random(#normalNumbers)
  local x = map(normalNumbers[indexX], 0, MAX_HEIGHT, 0, 1)
  if indexX < #normalNumbers / 2 then
    x = x * -1
  end

  local indexY = math.random(#normalNumbers)
  local y = map(normalNumbers[indexY], 0, MAX_HEIGHT, 0, 1)
  if indexY < #normalNumbers / 2 then
    y = y * -1
  end

  self.x = self.x + x
  self.y = self.y + y
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
