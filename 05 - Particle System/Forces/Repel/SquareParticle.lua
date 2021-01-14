SquareParticle = Particle:new()

function SquareParticle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  love.graphics.rectangle(
    "fill",
    self.position.x - SIZE_PARTICLE / 2,
    self.position.y - SIZE_PARTICLE / 2,
    SIZE_PARTICLE,
    SIZE_PARTICLE
  )
end
