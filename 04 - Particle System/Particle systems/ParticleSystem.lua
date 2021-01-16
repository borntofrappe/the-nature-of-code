require "Particle"

ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:new(x, y)
  local origin = LVector:new(x, y)
  local this = {
    ["origin"] = origin,
    ["particles"] = {},
    ["lifespan"] = 0
  }

  setmetatable(this, self)
  return this
end

function ParticleSystem:update(dt)
  self.lifespan = self.lifespan + dt
  if math.random(math.ceil(self.lifespan)) == 1 then
    table.insert(self.particles, Particle:new(self.origin.x, self.origin.y))
  end
  for i = #self.particles, 1, -1 do
    self.particles[i]:update(dt)
    if self.particles[i]:isDead() then
      table.remove(self.particles, i)
    end
  end
end

function ParticleSystem:render()
  for i, particle in ipairs(self.particles) do
    particle:render()
  end
end
