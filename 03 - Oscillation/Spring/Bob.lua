Bob = {}
Bob.__index = Bob

function Bob:new(x, y)
  local position = LVector:new(x, y)
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["mass"] = MASS
  }

  setmetatable(this, self)
  return this
end

function Bob:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt))
  self.velocity:add(LVector:multiply(self.acceleration, dt))
  self.velocity:multiply(DAMPING)
  self.acceleration:multiply(0)
end

function Bob:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, BOB_RADIUS)
end

function Bob:applyForce(force)
  self.acceleration:add(LVector:divide(force, self.mass))
end
