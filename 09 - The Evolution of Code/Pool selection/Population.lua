Population = {}
Population.__index = Population

function Population:new(size, target, mutationOdds)
  local characters = {}

  local start = string.byte("A")
  local finish = string.byte("z")

  for i = start, finish do
    table.insert(characters, string.char(i))
  end

  table.insert(characters, " ")
  table.insert(characters, ",")
  table.insert(characters, ".")

  local population = {}
  local length = #target
  for i = 1, size do
    table.insert(population, DNA:new(characters, length))
  end

  local generation = 0

  local this = {
    ["size"] = size,
    ["population"] = population,
    ["target"] = target,
    ["mutationOdds"] = mutationOdds,
    ["generation"] = generation,
    ["characters"] = characters
  }

  setmetatable(this, self)
  return this
end

function Population:select(maxFitnessRatio)
  while true do
    local dna = self.population[math.random(#self.population)]
    local fitnessRatio = dna:getFitnessRatio(self.target)
    fitnessRatio = fitnessRatio ^ 2
    local probability = math.random() * maxFitnessRatio
    if probability < fitnessRatio then
      return dna
    end
  end
end

function Population:reproduce()
  local maxFitnessRatio = 0

  for i, dna in ipairs(self.population) do
    local fitnessRatio = dna:getFitnessRatio(self.target)
    if fitnessRatio > maxFitnessRatio then
      maxFitnessRatio = fitnessRatio
    end
  end

  local population = {}

  for i = 1, self.size do
    local parent1 = self:select(maxFitnessRatio)
    local parent2 = self:select(maxFitnessRatio)

    local child = DNA:new(self.characters, #self.target)
    child:inherit(parent1, parent2, self.mutationOdds)

    table.insert(population, child)
  end

  self.population = population
  self.generation = self.generation + 1
end

function Population:getBestMatch()
  local bestMatch = nil

  for i, dna in ipairs(self.population) do
    if not bestMatch or dna:getFitnessRatio(self.target) > bestMatch:getFitnessRatio(self.target) then
      bestMatch = dna
    end
  end

  return bestMatch
end
