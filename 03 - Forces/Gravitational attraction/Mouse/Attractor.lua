Attractor = {}
Attractor.__index = Attractor

function Attractor:new()
  local position = LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  this = {
    ["position"] = position,
    ["mass"] = MASS_ATTRACTOR,
    ["r"] = 1
  }

  setmetatable(this, self)
  return this
end

function Attractor:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Attractor:attract(mover)
  local r = LVector:subtract(self.position, mover.position)
  local d = r:getMagnitude()
  d = math.max(DISTANCE_MIN, math.min(DISTANCE_MAX, d))
  r:normalize()

  local force = LVector:multiply(r, GRAVITATIONAL_FORCE * self.mass * mover.mass / d ^ 2)
  return force
end
