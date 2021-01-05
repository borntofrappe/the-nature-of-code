Mover = {}
Mover.__index = Mover

--[[ _Please note_
  each randomWalk function overrides the previous one
  comment out the methods to display the different options 
]]
function Mover:new()
  this = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

-- [0; -1] or [1; 0] or [0; 1] or [-1; 0]
function Mover:randomWalk()
  local direction = math.random(4)
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

-- [[-1 | 0 | 1] ; [-1 | 0 | 1]]
function Mover:randomWalk()
  local dx = math.random(3) - 2
  local dy = math.random(3) - 2
  self.x = self.x + dx
  self.y = self.y + dy
end

-- [(-0.5, 0.5) ; (-0.5, 0.5)]
function Mover:randomWalk()
  local dx = math.random() - 0.5
  local dy = math.random() - 0.5
  self.x = self.x + dx
  self.y = self.y + dy
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
