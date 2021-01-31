DNA = {}
DNA.__index = DNA

function DNA:new(characters, length)
  local genes = {}

  for i = 1, length do
    table.insert(genes, characters[math.random(#characters)])
  end

  local this = {
    ["genes"] = genes
  }

  setmetatable(this, self)
  return this
end

function DNA:getFitnessRatio(target)
  local fitness = 0
  for i = 1, #self.genes do
    if self.genes[i] == target:sub(i, i) then
      fitness = fitness + 1
    end
  end

  return fitness / #target
end

function DNA:getSentence()
  return table.concat(self.genes)
end

function DNA:inherit(dna1, dna2, mutationOdds)
  for i = 1, #self.genes do
    if math.random(mutationOdds) ~= 1 then
      self.genes[i] = dna1.genes[i] or dna2.genes[i]
    end
  end
end
