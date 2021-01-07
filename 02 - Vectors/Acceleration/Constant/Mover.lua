Mover = {}
Mover.__index = Mover

function Mover:new()
  local position = LVector:new(0, math.floor(WINDOW_HEIGHT / 2))

  local vx = math.random(VELOCITY_MIN, VELOCITY_MAX)
  local vy = 0
  local velocity = LVector:new(vx, vy)
  local acceleration = LVector:new(0, 0)

  this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt))
  self.velocity:add(LVector:multiply(self.acceleration, dt))
  self.velocity:limit(VELOCITY_UPPER_THRESHOLD)

  if self.position.x > WINDOW_WIDTH + self.r then
    self.position.x = -self.r
  end

  if love.keyboard.isDown("up") and self.velocity.x < VELOCITY_UPPER_THRESHOLD then
    self.acceleration.x = ACCELERATION
  elseif love.keyboard.isDown("down") and self.velocity.x > VELOCITY_LOWER_THRESHOLD then
    self.acceleration.x = ACCELERATION * -1
  else
    self.acceleration.x = 0
  end
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
