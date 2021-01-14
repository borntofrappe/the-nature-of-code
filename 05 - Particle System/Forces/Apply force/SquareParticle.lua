SquareParticle = Particle:new()

function SquareParticle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  love.graphics.rectangle("fill", self.position.x - SIZE / 2, self.position.y - SIZE / 2, SIZE, SIZE)
end
