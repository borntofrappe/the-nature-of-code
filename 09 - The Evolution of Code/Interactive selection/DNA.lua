DNA = {}
DNA.__index = DNA

function DNA:new(length)
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

function DNA:inherit(parent1, parent2, mutationOdds)
  local genes = {}
  for i = 1, #self.genes do
    if math.random(mutationOdds) ~= 1 then
      self.genes[i] = i % 2 == 0 and parent1.dna.genes[i] or parent2.dna.genes[i]
    end
  end
end
