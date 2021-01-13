Particle = {}
-- !! set the index in :new() instead
-- Particle.__index = Particle

function Particle:new(x, y)
  local position = LVector:new(x, y)
  local vx = math.random(VELOCITY_X_MAX * -1, VELOCITY_X_MAX)
  local vy = math.random(VELOCITY_Y_MIN, VELOCITY_Y_MAX) * -1
  local velocity = LVector:new(vx, vy)
  local acceleration = LVector:new(0, GRAVITY)

  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["lifespan"] = 1
  }

  self.__index = self
  setmetatable(this, self)
  return this
end

function Particle:isDead()
  return self.lifespan == 0
end

function Particle:update(dt)
  self.lifespan = math.max(0, self.lifespan - dt * UPDATE_SPEED)
  self.position:add(LVector:multiply(self.velocity, dt))
  self.velocity:add(LVector:multiply(self.acceleration, dt))
end

function Particle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  love.graphics.circle("fill", self.position.x, self.position.y, RADIUS)
end
