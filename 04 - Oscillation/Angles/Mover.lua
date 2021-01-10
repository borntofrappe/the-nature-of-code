Mover = {}
Mover.__index = Mover

function Mover:new()
  local width = math.random(WIDTH_MIN, WIDTH_MAX)
  local height = math.random(HEIGHT_MIN, HEIGHT_MAX)
  local x = math.random(width, WINDOW_WIDTH - width)
  local y = math.random(height, WINDOW_HEIGHT - height)
  local angle = math.random(ANGLE_MIN, ANGLE_MAX)

  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["angle"] = angle
  }

  setmetatable(this, self)
  return this
end

function Mover:render()
  love.graphics.push()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(math.rad(self.angle))

  -- love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height, 0, 1, 1, self.width / 2, self.height / 2)

  -- love.graphics.setColor(0.13, 0.86, 0.72)
  -- love.graphics.circle("fill", 0, 0, 2)
  love.graphics.pop()
end
