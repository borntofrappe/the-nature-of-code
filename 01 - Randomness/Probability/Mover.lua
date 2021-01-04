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
direction     values    rough percentage
north         2         14%
west          4         28%
south         2         14%
east          6         42%
total         14

direction     rough percentage
north         14%
west          28%
south         14%
east          42%
]]
function Mover:randomWalk()
  local bucket = {1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4}
  local index = math.random(#bucket)
  local direction = bucket[index]
  if direction == 1 then
    self.y = self.y - 1
  elseif direction == 2 then
    self.x = self.x + 1
  elseif direction == 3 then
    self.y = self.y + 1
  elseif direction == 4 then
    self.x = self.x - 1
  end
end

--[[
direction     percentage
north         50%
west          5%
south         30%
east          15%
]]
function Mover:randomWalk()
  local direction = 0
  local probabilities = {0.5, 0.05, 0.3, 0.15}
  local probability = math.random()

  for i = 1, #probabilities do
    local cumulativeProbability = 0
    for j = 1, i do
      cumulativeProbability = cumulativeProbability + probabilities[j]
    end

    if probability < cumulativeProbability then
      direction = i
      break
    end
  end

  if direction == 1 then
    self.y = self.y - 1
  elseif direction == 2 then
    self.x = self.x + 1
  elseif direction == 3 then
    self.y = self.y + 1
  elseif direction == 4 then
    self.x = self.x - 1
  end
end

function Mover:render()
  love.graphics.setColor(0.12, 0.12, 0.13)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
