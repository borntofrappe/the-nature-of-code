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

--[[ 
(0; 1) range
higher values are more likely to be picked
]]
function Mover:randomWalk()
  local x = math.random()
  while true do
    local probability = math.random()
    if probability < x then
      break
    else
      x = math.random()
    end
  end

  local y = math.random()
  while true do
    local probability = math.random()
    if probability < y then
      break
    else
      y = math.random()
    end
  end

  if math.random() > 0.5 then
    x = x * -1
  end

  if math.random() > 0.5 then
    y = y * -1
  end

  self.x = self.x + x
  self.y = self.y + y
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
