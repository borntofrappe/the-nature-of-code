Mover = {}
Mover.__index = Mover

function Mover:new(mass)
  local r = RADIUS_MOVER * mass
  local position = LVector:new(math.random(r, WINDOW_WIDTH - r), math.random(r, WINDOW_HEIGHT - r))
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)

  local this = {
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
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Mover:applyForce(force)
  self.acceleration:add(LVector:divide(force, self.mass))
end

function Mover:repulse(mover)
  local r = LVector:subtract(self.position, mover.position)
  local d = r:getMagnitude()
  d = math.max(DISTANCE_MIN, math.min(DISTANCE_MAX, d))
  r:normalize()

  local force = LVector:multiply(r, REPULSION_FORCE * self.mass * mover.mass / d ^ 2)
  force:multiply(-1)
  return force
end
