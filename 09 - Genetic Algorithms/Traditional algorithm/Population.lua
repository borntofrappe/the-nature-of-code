require "DNA"

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
    ["selection"] = {},
    ["characters"] = characters
  }

  setmetatable(this, self)
  return this
end

function Population:select()
  local maxFitnessRatio = 0

  for i, dna in ipairs(self.population) do
    local fitnessRatio = dna:getFitnessRatio(self.target)
    if fitnessRatio > maxFitnessRatio then
      maxFitnessRatio = fitnessRatio
    end
  end

  local selection = {}
  for i, dna in ipairs(self.population) do
    local fitnessRatio = map(dna:getFitnessRatio(self.target), 0, maxFitnessRatio, 0, 1)
    fitnessRatio = fitnessRatio ^ 2
    local n = math.floor(fitnessRatio * 100)
    for j = 1, n do
      table.insert(selection, dna)
    end
  end

  -- ensure that the collection has at least two elements
  while #selection < 1 do
    table.insert(selection, self.population[math.random(#self.population)])
  end

  self.selection = selection
end

function Population:reproduce()
  local selection = self.selection
  local population = {}

  for i = 1, self.size do
    local index1 = math.random(#selection)
    local index2
    repeat
      index2 = math.random(#selection)
    until index2 ~= index1

    local parent1 = selection[index1]
    local parent2 = selection[index2]

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

  return self.population[1]
end
