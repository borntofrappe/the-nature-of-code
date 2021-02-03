DNA = {}
DNA.__index = DNA

function DNA:new(length)
  local length = length or 1
  local genes = {}

  for i = 1, length do
    table.insert(genes, math.random())
  end

  local this = {
    ["genes"] = genes
  }

  setmetatable(this, self)
  return this
end

function DNA:inherit(parent)
  local variation = 1 + BLOOP_RADIUS_VARIATION_PERCENTAGE / 2 - math.random() * BLOOP_RADIUS_VARIATION_PERCENTAGE
  for i = 1, #self.genes do
    self.genes[i] = parent.dna.genes[i] * variation
  end
end
