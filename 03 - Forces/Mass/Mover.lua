Mover = {}
Mover.__index = Mover

function Mover:new(mass)
  local r = RADIUS * mass
  local position = LVector:new(math.random(r, WINDOW_WIDTH - r), math.random(r, WINDOW_HEIGHT / 2))
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)

  this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["mass"] = mass,
    ["r"] = r
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt))
  self.velocity:add(LVector:multiply(self.acceleration, dt))
  self.velocity:limit(VELOCITY_UPPER_THRESHOLD)
  self.acceleration:multiply(0)

  if (self.position.x + self.r > WINDOW_WIDTH) or (self.position.x - self.r < 0) then
    self.velocity.x = self.velocity.x * -1
  end

  if (self.position.y + self.r > WINDOW_HEIGHT) or (self.position.y - self.r < 0) then
    self.velocity.y = self.velocity.y * -1
  end
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Mover:applyForce(force)
  self.acceleration:add(LVector:divide(force, self.mass))
end
