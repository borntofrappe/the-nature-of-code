Mover = {}
Mover.__index = Mover

function Mover:new()
  local position = LVector:new(math.random(WINDOW_WIDTH), math.random(WINDOW_HEIGHT))

  local vx = math.random(VELOCITY_MIN, VELOCITY_MAX)
  local vy = math.random(VELOCITY_MIN, VELOCITY_MAX)
  if math.random() > 0.5 then
    vx = vx * -1
  end
  if math.random() > 0.5 then
    vy = vy * -1
  end

  local velocity = LVector:new(vx, vy)

  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt))

  if self.position.x < -self.r then
    self.position.x = WINDOW_WIDTH + self.r
  end
  if self.position.x > WINDOW_WIDTH + self.r then
    self.position.x = -self.r
  end

  if self.position.y < -self.r then
    self.position.y = WINDOW_HEIGHT + self.r
  end
  if self.position.y > WINDOW_HEIGHT + self.r then
    self.position.y = -self.r
  end
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
