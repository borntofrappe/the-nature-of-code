Mover = {}
Mover.__index = Mover

function Mover:new(mass)
  local position = LVector:new(WINDOW_WIDTH / 4, WINDOW_HEIGHT / 4)
  local velocity = LVector:new(math.random(VELOCITY_MIN, VELOCITY_MAX), 0)
  local acceleration = LVector:new(0, 0)

  this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["mass"] = 1,
    ["r"] = RADIUS_MOVER
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt))
  self.velocity:add(LVector:multiply(self.acceleration, dt))
  self.velocity:limit(VELOCITY_UPPER_THRESHOLD)
  self.acceleration:multiply(0)
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Mover:applyForce(force)
  self.acceleration:add(LVector:divide(force, self.mass))
end
