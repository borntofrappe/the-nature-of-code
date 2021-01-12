require "Particle"

ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:new()
  this = {
    ["origin"] = origin or LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2),
    ["particles"] = {}
  }

  setmetatable(this, self)
  return this
end

function ParticleSystem:update(dt)
  table.insert(self.particles, Particle:new(LVector:copy(self.origin)))
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
