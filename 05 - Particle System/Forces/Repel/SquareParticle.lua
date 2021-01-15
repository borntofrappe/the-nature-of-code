SquareParticle = Particle:new()

function SquareParticle:new(x, y)
  local this = Particle.new(self, x, y)
  this.angle = 0
  this.angularVelocity = 0
  this.angularAcceleration = ANGULAR_ACCELERATION
  return this
end

function SquareParticle:update(dt)
  Particle.update(self, dt)
  self.angle = self.angle + self.angularVelocity * dt
  self.angularVelocity = self.angularVelocity + self.angularAcceleration * dt
  self.angularAcceleration = self.position.x > WINDOW_WIDTH / 2 and ANGULAR_ACCELERATION or ANGULAR_ACCELERATION * -1
end

function SquareParticle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  love.graphics.push()
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.rotate(self.angle)
  love.graphics.rectangle("fill", -SIZE_PARTICLE / 2, -SIZE_PARTICLE / 2, SIZE_PARTICLE, SIZE_PARTICLE)
  love.graphics.pop()
end
