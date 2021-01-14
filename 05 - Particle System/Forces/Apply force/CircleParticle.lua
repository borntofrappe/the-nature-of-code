CircleParticle = Particle:new()

-- function CircleParticle:new(x, y)
--   return Particle:new(x, y)
-- end

function CircleParticle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  love.graphics.circle("fill", self.position.x, self.position.y, RADIUS)
end
