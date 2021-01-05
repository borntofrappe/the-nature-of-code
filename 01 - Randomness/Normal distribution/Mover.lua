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

function Mover:randomWalk(randomNumbers)
  local indexX = math.random(#randomNumbers)
  local x = map(randomNumbers[indexX], 0, MAX_HEIGHT, 0, 1)
  if indexX < #randomNumbers / 2 then
    x = x * -1
  end

  local indexY = math.random(#randomNumbers)
  local y = map(randomNumbers[indexY], 0, MAX_HEIGHT, 0, 1)
  if indexY < #randomNumbers / 2 then
    y = y * -1
  end

  self.x = self.x + x
  self.y = self.y + y
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
